require 'test_helper'

class Scheduler::LibTest < ActiveSupport::TestCase

  test "get_token" do
    token = Scheduler::Lib.get_token

    assert_equal 32, token.length
  end

  test "write_cache and read_cache" do
    Scheduler::Lib.write_cache("test", "value")
    assert_equal "value", Scheduler::Lib.read_cache("test")
  end

  test "create_item" do
    item = Scheduler::Lib.create_item(
      Application,
      {title: "test"},
      description: 'tt',
    )
    assert item.persisted?
    assert_equal "test", item.title
    assert_equal "tt", item.description

    # can update
    old_item = item
    item = Scheduler::Lib.create_item(
      Application,
      {title: "test"},
      description: 'pp',
    )
    assert_equal old_item.id, item.id
    assert_equal "pp", item.description
  end

  test "create_plan" do
    app = Application.create!(name: "test_app")
    plan = Scheduler::Lib.create_plan(
      "test_app",
      "UTC",
      "test_plan",
      "0 0 * * *",
    )

    assert plan.persisted?
    assert_equal "test_plan", plan.title
    assert_equal app.id, plan.application_id
    assert_equal 600, plan.waiting

    execution_method = plan.execution_method
    assert execution_method.persisted?
    assert_equal "mapping for crontab", execution_method.title

    routine = plan.routines.first
    assert routine.persisted?
    assert_equal "UTC", routine.timezone
    assert_equal("0 0 * * *", routine.config)
  end

end
