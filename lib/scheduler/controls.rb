class Scheduler::Controls
  KINDS = {
    execution: {
      check: "Similar with background routine check",
      run: "Only run current executions",
      expand: "Only expand execution by current plan routine",
      verify: "Only verify running executions",
    },
    report: {
      export: "Export configuration as json file",
    },
    email: {
      test: "Test if send eamil feature is working",
      timeout: "Test timeout email format, use last 3 executions",
      daily_report: "Test daily report for current user",
    },
    job: {
      scheduler_check: "Run Scheduler::Runner.check",
      daily_report: "For users enabled email_daily_report, send emails",
    },
    test: {
      ok: "Just show ok",
      error: "Test error will get reported",
      sentry_error: "Test can trigger sentry error",
      job: "Test background job is running",
      job_error: "Test background job raise error"
    },
  }
  KIND_LIST = KINDS.map do |category, h|
    h.keys.map{ |n| [category, n].map(&:to_s).join("_") }
  end.flatten

  EXECUTION_TYPES = {
    'execution_check' => 'check',
    'execution_run' => 'run_executions',
    'execution_expand' => 'expand_executions',
    'execution_verify' => 'verify_executions',
  }

  class << self

    def run(type, opt={})
      case type
      when 'execution_check', 'execution_run', 'execution_expand', 'execution_verify'
        type = EXECUTION_TYPES.fetch(type)
        Scheduler::Runner.send(type, Time.now)

      when 'job_scheduler_check', 'job_daily_report'
        name = (type.sub("job_", "") + "_job").camelcase
        name.constantize.perform_later
        {msg: "Job: #{name} enqueued"}

      else
        if KIND_LIST.include?(type)
          self.send(type, opt)
        else
          {msg: "Uknown type: #{type}"}
        end
      end
    end

    def report_export(opt)
      Plan.all.preload(:routines).map do |plan|
        d = plan.as_json
        d.delete('execution_method_id')
        d[:execution_method] = plan.execution_method.as_json
        d[:routines] = plan.routines.map(&:as_json)
        d
      end
    end

    def email_test(opt)
      UserMailer.test(opt[:user]).deliver_now
      {msg: "Email sent."}
    end

    def email_timeout(opt)
      UserMailer.timeout([opt[:user]], Execution.last(3)).deliver_now
      {msg: "Email sent."}
    end

    def email_daily_report(opt)
      DailyReportJob.new.perform(user_ids: opt[:user].id, update: false)
      {msg: "Email sent."}
    end

    def test_ok(opt)
      {msg: "OK"}
    end

    def test_error(opt)
      raise "test raising error"
    end

    def test_sentry_error(opt)
      Raven.capture do
        raise "catch sentry error"
      end
    end

    def test_job(opt)
      ok = TestJob.verify
      {msg: "Validate job: " + (ok ? 'ok' : 'failed')}
    end

    def test_job_error(opt)
      TestJob.perform_later('error')
      {msg: "queue job error"}
    end

  end
end
