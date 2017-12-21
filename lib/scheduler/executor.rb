class Scheduler::Executor
  class << self

    def perform(execution)
      self.send("execute_#{execution.plan.execution_method.execution_type}", execution)
    end

    def running(execution, after_status)
      now = Time.now
      execution.started_at = now
      execution.timeout_at = now + execution.plan.waiting.seconds
      begin
        execution.result = yield
        execution.status = after_status
      rescue Exception, RestClient::Exception, Errno::ECONNREFUSED => e
        execution.status = :error
        execution.log = ([e.message, ""] + e.backtrace).join("\n")
      end
      execution.save!
    end

    def execute_none(execution)
      self.running(execution, :calling){}
    end

    def execute_ruby(execution)
      method = execution.plan.execution_method
      self.running(execution, :succeeded) do
        eval method.parameters[:code]
      end
    end

    def execute_http(execution)
      plan = execution.plan
      method = plan.execution_method

      self.running(execution, :calling) do
        site = method.parameters[:site]
        path = plan.parameters[:path]
        RestClient.get("#{site}/#{path}")
      end
    end

    def execute_sidekiq(execution)
      plan = execution.plan
      method = plan.execution_method

      self.running(execution, :calling) do
        hash = plan.parameters.slice(:class, :args)
        opt = hash[:args].extract_options!
        execution.token = Scheduler::Lib.get_token
        opt[:token] = execution.token
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
