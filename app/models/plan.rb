class Plan < ActiveRecord::Base
  include HasParameters

  belongs_to :execution_method
  has_many :routines, dependent: :destroy
  has_many :executions, dependent: :destroy

end
