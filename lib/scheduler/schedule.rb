class Scheduler::Schedule
  class << self

    def parse(schedule)
      CronParser.new(schedule)
    end

    def description(schedule)
      Cronex::ExpressionDescriptor.new(schedule).description
    end

    def during(schedule, timezone, from, to, opt={})
      cron_parser = self.parse(schedule)
      out = []
      next_t = from

      tz = ActiveSupport::TimeZone.new(timezone)
      # convert time to timezone format
      next_t = tz.at(next_t)
      next_t -= opt[:modify].seconds if opt[:modify]

      ts = "%Y-%m-%d %H:%M:%S"
      # limit max count
      (1..1000).each do |i|
        # cron don't care about timezone
        next_t = cron_parser.next(next_t)
        # force convert timezone by value
        next_t = tz.strptime(next_t.strftime(ts), ts)

        break if next_t > to
        out_t = next_t
        out_t += opt[:modify].seconds if opt[:modify]
        out << out_t
      end
      out
    end

  end
end
