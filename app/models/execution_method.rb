class ExecutionMethod < ActiveRecord::Base
  include HasParameters
  include HasEnabled

  enum :execution_type, [:none, :ruby, :sidekiq, :http].map(&:to_s).index_by(&:itself)

  has_many :plans

end
