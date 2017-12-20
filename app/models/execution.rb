class Execution < ActiveRecord::Base
  include Enumerize
  include Reportable

  enumerize :status, in: Reportable::STATUSES + [:calling, :timeout]

  ERROR_STATUS = [:timeout, :error]

  belongs_to :routine, optional: :true
  belongs_to :plan

  def self.scheduled_during(from, to)
    self.
      where_if(from, "scheduled_at >= ?", from).
      where_if(to, "scheduled_at <= ?", to)
  end

  def self.runs_during(from, to)
    self.
      where_if(from, "started_at >= ?", from).
      where_if(to, "started_at <= ?", to)
  end

  def self.during(from, to)
    self.scheduled_during(from, to).or(
      self.runs_during(from, to))
  end

  def self.run
    self.run_at(Time.now)
  end

  def self.run_at(t)
    self.where.not(status: ['succeeded', 'error']).each do |e|
      e.perform
    end
  end

  def perform
    Scheduler::Executor.perform(self)
  end

  def close(status=:succeeded, result=nil)
    self.update_attributes!(status: status, result: result, finished_at: Time.now)
  end

end
