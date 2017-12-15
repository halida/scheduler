class Execution < ActiveRecord::Base
  extend Enumerize
  extend Reportable

  enumerize :status, in: Reportable::STATUSES + [:calling, :timeout]

  ERROR_STATUS = [:timeout, :error]

  belongs_to :routine
  belongs_to :plan

  def self.scheduled_during(from, to)
    self.
      where_if(from, "scheduled_at >= ?", from).
      where_if(to, "scheduled_at <= ?", to)
  end

  def run
    self.run_at(Time.now)
  end

  def run_at(t)
    self.where.not(status: ['succeeded', 'error']).each do |e|
      e.perform
    end
  end

  def perform
    Scheduler::Executor.perform(self)
  end

end
