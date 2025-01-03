class Plan < ApplicationRecord
  include HasParameters
  include HasEnabled
  include HasToken

  belongs_to :application, optional: true
  belongs_to :execution_method
  has_many :routines, dependent: :destroy
  has_many :executions, dependent: :destroy

  after_save :update_executions

  def update_executions
    return if self.enabled
    self.executions.where(status: :init).delete_all
  end

end
