module Loggable

  def log_info(msg, opt={})
    msg = "#{Time.now.strftime('%Y-%m-%dT%H:%M:%S.%2N')}\t#{msg}" if opt[:with_time]
    self.log_list << msg
  end
  alias_method :log_warning, :log_info

  def log_exception(e)
    self.log_info(e.message)
    self.log_info(e.backtrace.join("\n"))
  end

  def log_list
    @log_list ||= []
  end

  def log_list=(value)
    @log_list = value
  end

  def log_text
    self.log_list.compact.join("\n")
  end

  def clear_log
    self.log_list = []
    self.log = ""
  end

  def update_log
    self.log = self.log_text
  end

end
