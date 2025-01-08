class Scheduler::Info
  class << self

    def get(user)
      conn = ActiveRecord::Base.connection

      {environment: {
         rails: Rails.env,
       },
       version: {
         ruby: RUBY_VERSION,
         rails: Rails::VERSION::STRING,
       },
       database: {
         version: conn.select_value("SELECT @@version"),
         executions: Execution.count,
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
           time: Time.now.in_time_zone(user.timezone),
           zone: user.timezone,
         }
       },
      }
    end

  end
end
