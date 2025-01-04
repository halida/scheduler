class Routine < ApplicationRecord
  include HasEnabled

  belongs_to :plan
  has_many :executions

  enum :timezone, Scheduler::Lib::TIMEZONES.map(&:to_s).index_by(&:itself)

  validate :validate_data

  after_save :update_executions

  def title
    Scheduler::Schedule.description(self.config)
  end

  def update_executions
    if (self.saved_changes.has_key?('config') or
        self.timezone_changed? or
        self.enabled == false)
      self.executions.scheduled_after(Time.now).where(status: :init).delete_all
    end
  end

  def validate_data
    if self.config.present?
      parser = Scheduler::Schedule.parse(self.config) rescue nil
      unless parser
        errors.add :config, "is not valid."
        return
      end

      f = parser.next(DateTime.now)
      n = parser.next(f)
      if (n - f) < 10.minutes
        errors.add :config, "interval should not smaller than 10 minutes."
        return
      end
    end
  end

end
