require 'test_helper'

class Scheduler::Workflow::ApplicationTest < ActiveSupport::TestCase
  setup do
    @app = Application.create!(
      name: 'Test App',
      description: 'This is a test application',
      token: 'test-token',
      enabled: true,
    )

    @em = ExecutionMethod.create!(
      title: "mapping for crontab",
      execution_type: :no,
    )

    @plan = @app.plans.create!(
      title: 'Test Plan',
      execution_method: @em,
      enabled: true,
    )

    @execution = @plan.executions.create!(
      status: :calling,
    )
  end

  test "successful notification" do
    params = {
      application_id: 'test-token',
      plan_title: 'Test Plan',
      status: :succeeded,
      result: 'success',
    }

    result = Scheduler::Workflow::Application.notify_plan(params)

    assert_equal :succeeded, result[:status]
    assert_equal @app.id, result[:id]
    assert_equal @plan.id, result[:plan_id]
    assert_equal @execution.id, result[:execution_id]
    assert_equal "succeeded", @execution.reload.status
  end

  test "notification with invalid application" do
    params = {
      application_id: 'invalid-token',
      plan_title: 'Test Plan',
      status: :completed,
      result: 'success',
    }

    result = Scheduler::Workflow::Application.notify_plan(params)

    assert_equal :error, result[:status]
    assert_equal "no such application", result[:message]
  end

  test "notification with invalid plan" do
    params = {
      application_id: 'test-token',
      plan_title: 'Invalid Plan',
      status: :completed,
      result: 'success',
    }

    result = Scheduler::Workflow::Application.notify_plan(params)

    assert_equal :error, result[:status]
    assert_equal "no such plan", result[:message]
  end

  test "notification with no current execution" do
    @execution.destroy!

    params = {
      application_id: 'test-token',
      plan_title: 'Test Plan',
      status: :completed,
      result: 'success',
    }

    result = Scheduler::Workflow::Application.notify_plan(params)

    assert_equal :error, result[:status]
    assert_equal "no current execution", result[:message]
  end
end
