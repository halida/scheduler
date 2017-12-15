require 'test_helper'

class SchedulerTest < ActiveSupport::TestCase

  def create_plan(opt)
    plan = Plan.find_or_create_by(title: opt[:title])
    schedule = opt.delete(:schedule)
    opt[:execution_method_id] = opt.delete(:em).id
    plan.update_attributes!(opt)

    routine = plan.routines.find_or_create_by(config: schedule)
    Scheduler::Lib.routine_expend_executions(routine, Time.now)

    plan
  end

  def create_em(opt)
    em = ExecutionMethod.find_or_create_by(title: opt[:title])
    em.update_attributes!(opt)
    em
  end

  def execute_plan(plan)
    e = plan.routines.first.executions.first
    e.perform
    e
  end

  test "all" do
    # test ruby ok
    em_ruby_ok = create_em(
      title: "ruby test ok", execution_type: :ruby,
      parameters: {code: "1+1"},
    )
    plan = create_plan(title: "ruby test ok", em: em_ruby_ok, schedule: "31 2 * * *")
    e = execute_plan(plan)
    assert_equal e.status, 'succeeded'
    assert_equal e.result, '2'

    # test ruby error
    em_ruby_error = create_em(
      title: "ruby test error", execution_type: :ruby,
      parameters: {code: "1/0"},
    )
    plan = create_plan(title: "ruby test error", em: em_ruby_error, schedule: "31 2 * * *")
    e = execute_plan(plan)
    assert_equal e.status, "error"

    # test call api
    em_api = create_em(
      title: "ruby api", execution_type: :http,
      parameters: {site: "https://raw.githubusercontent.com"},
    )
    plan = create_plan(
      title: "ruby api", em: em_api, schedule: "31 2 * * *",
      parameters: {path: "/halida/data_list_converter/master/lib/data_list_converter/version.rb",
                   parameters: {}},
    )
    # e = execute_plan(plan)
    # assert_equal e.status, 'succeeded'
    # assert_equal e.result[0..5], 'class'

    # test call sidekiq
    em_sidekiq = create_em(
      title: "local sidekiq", execution_type: :sidekiq,
      parameters: {host: 'localhost', port: 6379, db: 14, queue: "default"},
    )
    plan = create_plan(
      title: "ruby api", em: em_sidekiq, schedule: "31 2 * * *",
      parameters: {class: "TestWorker", args: ['error']},
    )
    e = execute_plan(plan)
    Scheduler::Runner.verify_executions(Time.now)
    assert_equal e.reload.status, "calling"

    e.timeout_at -= 5.minutes
    e.save!
    Scheduler::Runner.verify_executions(Time.now)
    assert_equal e.reload.status, "timeout"
  end

end
