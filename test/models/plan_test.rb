require 'test_helper'

class PlanTest < ActiveSupport::TestCase

  test "all" do
    # check create
    em = ExecutionMethod.create!(execution_type: :no)
    plan = Plan.new
    plan.execution_method = em
    assert plan.enabled
    plan.save!

    # delete all executions if disabled
    plan.executions.create!
    assert_equal 1, plan.executions.count

    plan.update!(title: "abc")
    assert_equal 1, plan.executions.count

    plan.update!(enabled: false)
    assert_equal 0, plan.executions.count
  end

end
