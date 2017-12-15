class Scheduler::Executor
  class << self

    def perform(execution)
      self.send("execute_#{execution.routine.plan.execution_method.execution_type}", execution)
    end

    def monitor_error(execution, after_status)
      result = ""
      begin
        result = yield
      rescue Exception, RestClient::Exception, Errno::ECONNREFUSED => e
        after_status = :error
        result = ([e.message, ""] + e.backtrace).join("\n")
      end
      execution.update_attributes!(status: after_status, result: result)
    end

    def execute_ruby(execution)
      method = execution.routine.plan.execution_method
      self.monitor_error(execution, :succeeded) do
        eval method.parameters[:code]
      end
    end

    def execute_http(execution)
      plan = execution.routine.plan
      method = plan.execution_method

      self.monitor_error(execution, :calling) do
        site = method.parameters[:site]
        path = plan.parameters[:path]
        RestClient.get("#{site}/#{path}")
      end
    end

    def execute_sidekiq(execution)
      plan = execution.routine.plan
      method = plan.execution_method

      self.monitor_error(execution, :calling) do
        hash = plan.parameters.slice(:class, :args)
        opt = hash[:args].extract_options!
        opt[:execution_id] = execution.id
        hash[:args] << opt
        hash = hash.stringify_keys
        
        redis_client = Redis.new(method.parameters.slice(:host, :port, :db))
        sidekiq_client = Sidekiq::Client.new(ConnectionPool.new { redis_client })
        sidekiq_client.push(hash)
        nil
      end
    end

  end
end
