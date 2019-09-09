class Plan < ActiveRecord::Base
  include HasParameters
  include HasEnabled

  belongs_to :execution_method
  has_many :routines, dependent: :destroy
  has_many :executions, dependent: :destroy

  after_create :assign_token
  after_save :update_executions

  def update_executions
    return if self.enabled
    self.executions.where(status: :initialize).delete_all
  end

  def assign_token
    update_attributes!(token: Scheduler::Lib.get_token)
  end
end
