class Execution < ActiveRecord::Base
  include Enumerize
  include Reportable

  enumerize :status, in: Reportable::STATUSES + [:calling, :timeout]

  ERROR_STATUS = [:timeout, :error]

  belongs_to :routine, optional: :true
  belongs_to :plan

  def self.scheduled_during(from, to)
    self.scheduled_after(from).scheduled_before(to)
  end

  def self.scheduled_after(t)
    self.where_if(t, "scheduled_at >= ?", t)
  end

  def self.scheduled_before(t)
    self.where_if(t, "scheduled_at < ?", t)
  end

  def self.runs_during(from, to)
    self.
      where_if(from, "started_at >= ?", from).
      where_if(to, "started_at < ?", to)
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

  def self.errors
    self.where(status: [:timeout, :error])
  end

  def time
    self.scheduled_at || self.started_at
  end
  alias_method :title, :time

  def perform
    Scheduler::Executor.perform(self)
  end

  def close(status=:succeeded, result=nil)
    now = Time.now
    self.update_attributes!(status: status, result: result, finished_at: now)
  end

  def result_data
    return unless self.result.present?
    JSON.load(self.result) rescue self.result
  end

end
