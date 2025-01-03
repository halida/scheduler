class Scheduler::Info
  class << self

    def get
      {environment: {
         rails: Rails.env,
       },
       version: {
         ruby: RUBY_VERSION,
         rails: Rails::VERSION::STRING,
       },
       time: {
         system: {
           time: Time.now.to_s,
           zone: Time.now.zone,
         },
         rails: {
           time: Time.zone.now,
           zone: Time.zone.to_s,
         },
         user: {
           time: Time.now.in_time_zone(current_user.timezone),
           zone: current_user.timezone,
         }
       },
      }
    end

  end
end
