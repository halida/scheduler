class Scheduler::Lib
  class << self

    def parse_schedule(schedule)
      CronParser.new(schedule)
    end

    def schedule_description(schedule)
      Cronex::ExpressionDescriptor.new(schedule).description
    end
    
    def routine_expend_executions(routine, now)
      last = routine.executions.order(scheduled_at: :desc).first.try(:scheduled_at) || now

      # create next 2 week execution when near 1 week
      return if last > now + 7.days
      to = last + 14.days

      schedules = self.get_schedules_during(routine.config, last, to)
      schedules.map do |schedule|
        routine.executions.find_or_create_by!(
          plan_id: routine.plan.id,
          scheduled_at: schedule,
          timeout_at: now + routine.plan.waiting.seconds,
        )
      end
    end

    def plan_expend_executions(plan, now)
      plan.routines.where(enabled: true).map do |routine|
        self.routine_expend_executions(routine, now)
      end.flatten
    end

    def get_schedules_during(schedule, from, to)
      cron_parser = self.parse_schedule(schedule)
      out = []
      next_t = from - 1.second
      # limit max count
      (1..1000).each do |i|
        next_t = cron_parser.next(next_t)
        out << next_t
        break if next_t > to
      end
      out
    end

    def get_schedules_with_execution_during(plan, from, to)
      executions = plan.executions.during(from, to)
      schedules = \
      plan.routines.map do |routine|
        self.get_schedules_during(routine.config, from, to)
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

  end
end
