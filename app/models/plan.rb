class Plan < ActiveRecord::Base
  serialize :parameters, Hash

  belongs_to :execution_method
  has_many :routines
  has_many :executions

end
