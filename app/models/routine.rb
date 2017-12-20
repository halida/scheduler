class Routine < ActiveRecord::Base
  extend Enumerize
  include HasEnabled

  belongs_to :plan
  has_many :executions

  enumerize :timezone, in: [
              :"UTC",
              :"Etc/GMT-6",
              :"Central Time (US & Canada)",
              :"Asia/Shanghai",
            ]

  validate :validate_data

  after_save :update_executions

  def title
    Scheduler::Lib.schedule_description(self.config)
  end

  def update_executions
    if self.config_changed? or self.enabled == false
      self.executions.where(status: :initialize).delete_all
    end
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
      if (n - f) < 20.minutes
        errors.add :config, "interval should not smaller than 20 minutes."
        return
      end
    end
  end

end
