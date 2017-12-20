class ExecutionMethod < ActiveRecord::Base
  extend Enumerize
  enumerize :execution_type, in: [:none, :ruby, :sidekiq, :http]

  include HasParameters

  has_many :plans

end
