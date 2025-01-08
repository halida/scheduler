require 'rest-client'

class SchedulerApi
  class << self

    def config
      {domain: ENV["SCHEDULER_API_DOMAIN"],
       protocol: ENV["SCHEDULER_API_PROTOCOL"],
       application_token: ENV["SCHEDULER_API_APPLICATION_TOKEN"],
      }
    end

    def resource
      @r ||= \
      begin
        u = "#{config.protocol}://#{config.domain}"
        u += ":#{config.port}" if config['port']
        RestClient::Resource.new(u)
      end
    end

    def post(url, params)
      self.resource[url].post(params)
    end

    def get(url, params)
      self.resource[url].get(params: params)
    end

    def notify_execution(token, status, result)
      self.post("/api/executions/#{token}/notify",
                status: status, result: result.to_json)
    end

    def notify_plan(token, status, result)
      self.post("/api/plans/#{token}/notify",
                status: status, result: result.to_json)
    end

    def notify_application_plan(token, plan_title, status, result={})
      self.post("/api/applications/#{token}/notify_plan",
                plan_title: plan_title, status: status, result: result.to_json)
    end

    def notify_self_application_plan(plan_title, status, result={})
      token = self.config.application_token
      self.log(plan_title, status, result)
      self.notify_application_plan(token, plan_title, status, result)
    end

    def log(name, status, result)
      File.open(File.join(Rails.root, "log/scheduler_api.log"), 'a+') do |f|
        f << "#{Time.now} #{name} #{status} #{result}\n"
      end
    end

  end
end
