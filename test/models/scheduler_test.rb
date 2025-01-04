require 'test_helper'

class SchedulerTest < ActiveSupport::TestCase

  def create_plan(opt)
    plan = Plan.find_or_create_by(title: opt[:title])
    schedule = opt.delete(:schedule)
    timezone = opt.delete(:timezone).presence || "UTC"
    opt[:execution_method_id] = opt.delete(:em).id
    plan.update!(opt)

    routine = plan.routines.find_or_create_by!(config: schedule, timezone: timezone)
    plan
  end

  def create_em(opt)
    Scheduler::Lib.create_item(ExecutionMethod, {title: opt[:title]}, opt)
  end

  def execute_plan(plan)
    plan.workflow.expand_executions(Time.now)

    e = plan.executions.first
    e.perform
    e
  end

  test "all" do
    # test ruby ok
    em_ruby_ok = create_em(
      title: "ruby test ok",
      execution_type: :ruby,
      parameters: {code: "1+1"},
    )
    plan = create_plan(
      title: "ruby test ok",
      description: "test if ruby code runs OK",
      em: em_ruby_ok, schedule: "31 2 * * *")
    # create another routine
    routine = plan.routines.find_or_create_by(config: "24 8 * * *")
    routine.workflow.expand_executions(Time.now)

    e = execute_plan(plan)
    assert_equal e.status, 'succeeded'
    assert_equal e.result, '2'

    # test ruby error
    em_ruby_error = create_em(
      title: "ruby test error",
      execution_type: :ruby,
      parameters: {code: "1/0"},
    )
    plan = create_plan(
      title: "ruby test error",
      description: "test if ruby code runs not OK\n\n should show errors in the log",
      em: em_ruby_error, schedule: "31 2 * * *"
    )
    e = execute_plan(plan)
    assert_equal e.status, "error"

    # mapping to crontab
    em_cron = create_em(
      title: "mapping for crontab",
      execution_type: :no,
    )
    plan = create_plan(
      title: "TransguardPremiumFtpWorker.daily_job",
      description: "wrike task <a href='https://www.wrike.com/open.htm?id=110144285'>here</a>.",
      em: em_cron, schedule: "0 5 * * *", timezone: "Central Time (US & Canada)",
    )
    e = execute_plan(plan)
    assert_equal e.status, "calling"

    # test crontab
    plan = create_plan(
      title: "InvalidChecker::Runner.recheck_changes_on_invalid_records",
      description: "",
      em: em_cron, schedule: "0,30 * * * *", timezone: "Central Time (US & Canada)",
    )

    # mapping to faster crontab
    plan = create_plan(
      title: "heart beat crontab",
      description: "for testing fast running",
      em: em_cron, schedule: "12 * * * *",
    )
    e = execute_plan(plan)
    assert_equal e.status, "calling"

    # test call api
    # todo
    return
    em_api = create_em(
      title: "ruby api", execution_type: :http,
      parameters: {site: "https://raw.githubusercontent.com"},
    )
    plan = create_plan(
      title: "ruby api", em: em_api, schedule: "31 2 * * *",
      parameters: {path: "/halida/data_list_converter/master/lib/data_list_converter/version.rb",
                   parameters: {}},
    )
    e = execute_plan(plan)
    assert_equal e.status, 'succeeded'
    assert_equal e.result[0..5], 'class'

    # test call sidekiq
    # todo
    # em_sidekiq = create_em(
    #   title: "local sidekiq", execution_type: :sidekiq,
    #   parameters: {host: 'localhost', port: 6379, db: 14, queue: "default"},
    # )
    # plan = create_plan(
    #   title: "test scheduler worker", em: em_sidekiq, schedule: "31 2 * * *",
    #   parameters: {class: "TestSchedulerWorker", args: []},
    # )
    # e = execute_plan(plan)
    # Scheduler::Runner.verify_executions(Time.now)
    # assert_equal e.reload.status, "calling"

    # e.timeout_at -= 5.minutes
    # e.save!

    # user = User.find_or_create_by(email: "test@test.com")
    # user.update!(email_notify: true)
    # Scheduler::Runner.verify_executions(Time.now)
    # assert_equal e.reload.status, "timeout"
  end

end
