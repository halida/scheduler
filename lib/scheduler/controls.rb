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
    test: {
      ok: "Just show ok",
      error: "Test error will get reported",
      send_email: "Test email will send correctly",
      job: "Test background job is running",
      job_error: "Test background job raise error"
    },
  }

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

      when "report_export"
        Plan.all.preload(:routines).map do |plan|
          d = plan.as_json
          d.delete('execution_method_id')
          d[:execution_method] = plan.execution_method.as_json
          d[:routines] = plan.routines.map(&:as_json)
          d
        end

      when "test_ok"
        {msg: "OK"}

      when "test_error"
        raise "test raising error"

      when "test_send_email"
        UserMailer.test_email(opt[:user]).deliver_now
        {msg: "Email sent."}

      when "test_job"
        ok = TestJob.verify
        {msg: (ok ? 'validate_job_ok' : 'validate_job_failed')}

      when "test_job_error"
        TestJob.perform_later('error')
        {msg: "queue job error"}

      else
        raise NotImplementedError
      end

    end

  end
end
