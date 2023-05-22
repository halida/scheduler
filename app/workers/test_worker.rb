class TestWorker
  include Sidekiq::Worker

  def perform(action, *args)
    case action
    when 'validate'
      id = args.first
      Rails.cache.write("validate_worker_#{id}", 'ok', expires_in: 1.day)
    when 'error'
      raise 'check worker error'
    else
      raise "action unknown: #{action}"
    end
  end

  def self.verify
    id = SecureRandom.uuid.to_s
    self.perform_async("validate", id)
    (1..2).each do
      sleep(5)
      result = Rails.cache.read("validate_worker_#{id}")
      return true if result == 'ok'
    end
    return false
  end

end
