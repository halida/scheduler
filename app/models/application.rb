class Application < ApplicationRecord
  include HasToken

  has_many :plans, dependent: :destroy
  has_many :executions, through: :plans

  alias_attribute :title, :name

end
