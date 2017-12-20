class Plan < ActiveRecord::Base
  serialize :parameters, Hash

  belongs_to :execution_method
  has_many :routines, dependent: :destroy
  has_many :executions, dependent: :destroy

end
