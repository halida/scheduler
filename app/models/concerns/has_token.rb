module HasToken
  extend ActiveSupport::Concern

  included do
    after_create :assign_token
  end

  def assign_token
    update!(token: Scheduler::Lib.get_token)
  end
end
