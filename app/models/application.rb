class Application < ApplicationRecord
  include HasToken

  has_many :plans

  alias_attribute :title, :name

end
