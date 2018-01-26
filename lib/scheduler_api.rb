class SchedulerApi
  class << self
    def config
      OpenStruct.new(
        domain: 'scheduler.dev',
        protocol: 'http',
        plans: {
          test_plan: 'token',
        }
      )
    end

    def post(url, params)
      RestClient.post(url, params)
    end

    def notify_execution(token, status, result)
      self.post("#{config.protocol}://#{config.domain}/api/executions/#{token}/notify",
                status: status, result: result.to_json)
    end

    def notify_plan(token, status, result)
      self.post("#{config.protocol}://#{config.domain}/api/plans/#{token}/notify",
                status: status, result: result.to_json)
    end

    # Usage:
    # SchedulerApi.notify_plan_with_name('test_plan', :succeeded, result)
    def notify_plan_with_name(name, status, result={})
      return unless (
          config = self.config and
          plans = self.config.plans || {}
          token = plans[name.to_sym]
        )
      File.open(File.join(Rails.root, "log/scheduler_api.log"), 'a+') do |f|
        f << "#{Time.now} #{name} #{status} #{result}\n"
      end
      result = {
        name: name,
        finished_at: Time.now,
        result: result,
      }
      SchedulerApi.notify_plan(token, status, result)
    end
  end
end
