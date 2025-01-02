class TestJob < ApplicationJob
  queue_as :default

  def perform(action, *args)
    case action
    when 'validate'
      id = args.first
      Rails.cache.write("validate_job_#{id}", 'ok', expires_in: 1.day)
    when 'error'
      raise 'check job error'
    else
      raise "action unknown: #{action}"
    end
  end

  def self.verify
    id = SecureRandom.uuid.to_s
    self.perform_later("validate", id)
    (1..2).each do
      sleep(5)
      result = Rails.cache.read("validate_job_#{id}")
      return true if result == 'ok'
    end
    return false
  end

end
