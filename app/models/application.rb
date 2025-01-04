class Application < ApplicationRecord
  include HasToken

  has_many :plans, dependent: :destroy

  alias_attribute :title, :name

end
