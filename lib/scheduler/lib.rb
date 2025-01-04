class Scheduler::Lib

  TIMEZONES = [
    :"UTC",
    :"Etc/GMT-6",
    :"Central Time (US & Canada)",
    :"Asia/Shanghai",
  ]

  class << self

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

    def import(name, tz, list)
      app = Application.find_by(name: name)

      exists = app.plans.where(title: list.map(&:last)).pluck(:title)
      missing = list.reject{|cfg, script| exists.include?(script)}

      missing.each do |cfg, plan_name|
        create_plan(name, tz, plan_name, cfg)
      end
    end

    def create_plan(app_name, tz, plan_name, cfg)
      app = Application.find_by(name: app_name)

      em_cron = create_item(
        ExecutionMethod, {title: "mapping for crontab"},
        execution_type: :no,
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
      plan.workflow.expand_executions(Time.now)
      plan
    end

    def create_item(klass, keys, parameters)
      item = klass.find_or_create_by!(keys)
      item.update!(parameters)
      item
    end

  end
end
