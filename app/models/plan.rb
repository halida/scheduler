class Plan < ActiveRecord::Base
  include HasParameters
  include HasEnabled

  belongs_to :execution_method
  has_many :routines, dependent: :destroy
  has_many :executions, dependent: :destroy

  after_save :update_executions

  def update_executions
    return if self.enabled
    self.executions.where(status: :initialize).delete_all
  end

end
