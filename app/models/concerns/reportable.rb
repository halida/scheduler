module Reportable
  include Loggable

  STATUSES = [:initialize, :generating, :succeeded, :error]

  def on_perform(opt={})
    # save first to get a id, so records can link with it
    self.status = :generating
    self.clear_log unless opt[:reserve_log]
    self.save

    self.record_duration do
      self.record_error do
        yield
        # status won't be succeeded if other things happens
        self.status = :succeeded
      end
    end
  ensure
    self.update_log
    self.save
  end

  def record_error
    yield
  rescue Exception, RestClient::Exception, Errno::ECONNREFUSED => e
    # and update report status
    self.status = :error
    ["", e.message, "", e.backtrace].flatten.compact.each do |row|
      self.log_info row
    end
    self.save
    # and raise it eventually
    raise e
  end

  def record_duration
    self.started_at = Time.now
    yield
  ensure
    self.finished_at = Time.now
  end

  def succeeded?
    self.status == 'succeeded'
  end

  def done?
    ['succeeded', 'error'].include?(self.status)
  end

end
