class Application < ApplicationRecord

  has_many :plans

  after_create :assign_token

  def title
    name
  end

  def assign_token
    update_attributes!(token: Scheduler::Lib.get_token)
  end
end
