class ExecutionMethod < ActiveRecord::Base
  extend Enumerize
  enumerize :execution_type, in: [:ruby, :sidekiq, :http]
  serialize :parameters, Hash

  has_many :plans
end
