module HasToken
  extend ActiveSupport::Concern

  included do
    after_create :assign_token_if_blank
  end

  def assign_token_if_blank
    self.assign_token if token.blank?
  end

  def assign_token
    update!(token: Scheduler::Lib.get_token)
  end

end
