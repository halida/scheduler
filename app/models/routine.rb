class Routine < ActiveRecord::Base
  extend Enumerize

  belongs_to :plan
  has_many :executions

  enumerize :timezone, in: [
              :"UTC",
              :"Etc/GMT-6",
              :"Central Time (US & Canada)",
              :"Asia/Shanghai",
            ]

  validate :validate_data

  def self.enabled(v=true)
    where(enabled: v)
  end

  def validate_data
    if self.config.present?
      parser = Scheduler::Lib.parse_schedule(self.config) rescue nil
      unless parser
        errors.add :config, "is not valid."
        return
      end
      
      f = parser.next(DateTime.now)
      n = parser.next(f)
      if (n - f) < 3.hours
        errors.add :config, "interval should not smaller than 3 hours."
        return
      end
    end
  end

  def description
    Scheduler::Lib.schedule_description(self.config)
  end

  # def get_schedules_with_execution_during(from, to)
  #   executions = self.executions.scheduled_during(from, to)
  #   schedules = Job.get_schedules_during(self.schedule, from, to)
  #   Job.put_executions_to_schedules_gap(executions, schedules)
  # end

end
