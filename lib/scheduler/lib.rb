class Scheduler::Lib
  TIMEZONES = [
    :"UTC",
    :"Etc/GMT-6",
    :"Central Time (US & Canada)",
    :"Asia/Shanghai",
  ]

  class << self

    def parse_schedule(schedule)
      CronParser.new(schedule)
    end

    def schedule_description(schedule)
      Cronex::ExpressionDescriptor.new(schedule).description
    end

    def routine_expand_executions(routine, now)
      last = routine.executions.order(scheduled_at: :desc).first.try(:scheduled_at) || now
      last = now if last < now

      # create next 2 week execution when near 1 week
      return if last > now + 7.days
      to = [last, now].max + 14.days

      status = routine.plan.review_only ? :succeeded : :initialize
      schedules = self.routine_get_schedules_during(routine, last, to)
      schedules.map do |schedule|
        routine.executions.find_or_create_by!(
          plan_id: routine.plan.id,
          scheduled_at: schedule,
          status: status,
        )
      end
    end

    def plan_expand_executions(plan, now)
      plan.routines.where(enabled: true).map do |routine|
        self.routine_expand_executions(routine, now)
      end.flatten
    end

    def routine_get_schedules_during(routine, from, to)
      self.get_schedules_during(routine.config, routine.timezone, from, to, modify: routine.modify)
    end

    def get_schedules_during(schedule, timezone, from, to, opt={})
      cron_parser = self.parse_schedule(schedule)
      out = []
      next_t = from

      tz = ActiveSupport::TimeZone.new(timezone)
      # convert time to timezone format
      next_t = tz.at(next_t)
      next_t -= opt[:modify].seconds if opt[:modify]

      ts = "%Y-%m-%d %H:%M:%S"
      # limit max count
      (1..1000).each do |i|
        # cron don't care about timezone
        next_t = cron_parser.next(next_t)
        # force convert timezone by value
        next_t = tz.strptime(next_t.strftime(ts), ts)

        break if next_t > to
        out_t = next_t
        out_t += opt[:modify].seconds if opt[:modify]
        out << out_t
      end
      out
    end

    def get_schedules_with_execution_during(plan, from, to)
      executions = plan.executions.during(from, to)
      schedules = \
      plan.routines.map do |routine|
        self.routine_get_schedules_during(routine, from, to)
      end.flatten.sort
      self.put_executions_to_schedules_gap(executions, schedules)
    end

    def put_executions_to_schedules_gap(executions, schedules)
      out = []
      schedules.each_with_index do |s, i|
        s_next = schedules[i+1]
        es = executions.select do |e|
          t = e.scheduled_at || e.started_at
          ((!s or t >= s) and
           (!s_next or t < s_next))
        end
        out << OpenStruct.new(at: s, executions: es)
      end
      out
    end

    def get_token
      SecureRandom.uuid.gsub("-", "")
    end

    def write_cache(key, v)
      Rails.cache.write("scheduler_#{key}", Marshal.dump(v))
    end

    def read_cache(key)
      blob = Rails.cache.read("scheduler_#{key}")
      Marshal.load(blob) rescue nil
    end

    def import(name, list)
      app = Application.find_by(name: name)

      exists = app.plans.where(title: list.map(&:last)).pluck(:title)
      missing = list.reject{|cfg, script| exists.include?(script)}

      missing.each do |cfg, plan_name|
        create_plan(name, 'Central Time (US & Canada)', plan_name, cfg)
      end
    end

    def create_plan(app_name, tz, plan_name, cfg)
      app = Application.find_by(name: app_name)

      em_cron = create_item(
        ExecutionMethod, {title: "mapping for crontab"},
        execution_type: :none,
      )
      plan = create_item(
        Plan, {title: plan_name, execution_method_id: em_cron.id},
        waiting: 600, application_id: app.id,
      )
      routine = create_item(
        Routine, {plan_id: plan.id},
        config: cfg, timezone: tz, modify: -120,
      )
      plan.reload
      Scheduler::Lib.plan_expand_executions(plan, Time.now)
    end

    def create_item(klass, keys, parameters)
      item = klass.find_or_create_by!(keys)
      item.update!(parameters)
      item
    end

  end
end
