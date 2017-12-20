class ExecutionMethod < ActiveRecord::Base
  include HasParameters
  include HasEnabled
  include Enumerize
  enumerize :execution_type, in: [:none, :ruby, :sidekiq, :http]

  has_many :plans

end
