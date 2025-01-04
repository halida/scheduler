require 'test_helper'

class Scheduler::Workflow::RoutineTest < ActiveSupport::TestCase
  setup do
    @em = ExecutionMethod.create!(
      title: "mapping for crontab",
      execution_type: :no,
    )
    @plan = Plan.create!(
      title: 'Test Plan',
      execution_method: @em,
      enabled: true,
      review_only: false,
    )

    @routine = @plan.routines.create!(
      config: "1 3 * * *",
    )

    @now = Time.current
  end

  test "initial execution creation" do
    result = @routine.workflow.expand_executions(@now)
    assert_equal 14, result.size
    assert_equal "init", result.first.status
  end

  test "subsequent execution creation" do
    # Create initial executions
    @routine.workflow.expand_executions(@now)

    # already created
    result = @routine.workflow.expand_executions(@now)
    assert_nil result

    # Move forward 8 days to trigger new batch
    new_time = @now + 8.days
    result = @routine.workflow.expand_executions(new_time)

    assert_equal 14, result.size
    assert_equal new_time.beginning_of_day + 20.days, result.last.scheduled_at.beginning_of_day
  end

  test "execution creation for review-only plan" do
    @plan.update!(review_only: true)
    result = @routine.workflow.expand_executions(@now)
    assert_equal "succeeded", result.first.status
  end

end
