require 'test_helper'
require 'ostruct'

class Scheduler::Workflow::PlanTest < ActiveSupport::TestCase
  setup do
    @em = ExecutionMethod.create!(
      title: "mapping for crontab",
      execution_type: :no,
    )

    @plan = Plan.create!(
      title: 'Test Plan',
      execution_method: @em,
      token: 'test-token',
      enabled: true,
    )

    @routine = @plan.routines.create!(
      config: '1 1 * * *',
      enabled: true,
    )

    @execution = @plan.executions.create!(
      status: :calling,
    )
  end

  test "expand_executions with enabled routine" do
    now = Time.current
    result = @plan.workflow.expand_executions(now)
    assert_equal 14, result.size
  end

  test "expand_executions with disabled routine" do
    @routine.update!(enabled: false)
    now = Time.current
    result = @plan.workflow.expand_executions(now)
    assert_equal 0, result.size
  end

  test "expand_executions with no routines" do
    @routine.destroy!
    now = Time.current
    result = @plan.workflow.expand_executions(now)
    assert_equal 0, result.size
  end

  test "get_schedules_with_execution_during" do
    from = Time.now
    to = from + 1.day
    out = @plan.workflow.get_schedules_with_execution_during(from, to)
    assert_equal 1, out.count
    assert_equal 0, out.first.executions.count

    # has execution created
    @plan.workflow.expand_executions(from)
    out = @plan.workflow.get_schedules_with_execution_during(from, to)
    assert_equal 1, out.count
    assert_equal 1, out.first.executions.count
  end

  test "put_executions_to_schedules_gap" do
    schedules = [Time.now, Time.now + 1.hour]
    executions = [
      OpenStruct.new(scheduled_at: Time.now + 30.minutes)
    ]
    result = @plan.workflow.class.put_executions_to_schedules_gap(executions, schedules)

    assert_equal 2, result.length
    assert_equal 1, result[0].executions.length
  end

  test "successful notification" do
    params = {
      plan_id: 'test-token',
      status: :succeeded,
      result: 'success',
    }

    result = Scheduler::Workflow::Plan.notify(params)

    assert_equal :succeeded, result[:status]
    assert_equal @plan.id, result[:id]
    assert_equal @execution.id, result[:execution_id]
    assert_equal 'succeeded', @execution.reload.status
  end

  test "notification with invalid plan" do
    params = {
      plan_id: 'invalid-token',
      status: :completed,
      result: 'success',
    }

    result = Scheduler::Workflow::Plan.notify(params)

    assert_equal :error, result[:status]
    assert_equal "no such plan", result[:message]
  end

  test "notification with no current execution" do
    @execution.destroy!

    params = {
      plan_id: 'test-token',
      status: :completed,
      result: 'success',
    }

    result = Scheduler::Workflow::Plan.notify(params)

    assert_equal :error, result[:status]
    assert_equal "no current execution", result[:message]
  end
end
