require 'test_helper'

class Scheduler::ScheduleTest < ActiveSupport::TestCase

  test "description" do
    desc = Scheduler::Schedule.description("0 0 * * *")
    assert_equal "At 12:00 AM", desc
  end

  test "during" do
    schedules = Scheduler::Schedule.during(
      "0 0 * * *",
      "UTC",
      Time.now,
      Time.now + 7.days,
    )
    assert_equal 7, schedules.length

    # test modify
    time = Time.utc(2021, 1, 1, 10, 0, 0)
    schedules = Scheduler::Schedule.during(
      "0 * * * *",
      "UTC",
      time,
      time + 3.hours,
      modify: 0,
    )
    assert_equal 3, schedules.length
    # modify
    schedules = Scheduler::Schedule.during(
      "0 * * * *",
      "UTC",
      time,
      time + 3.hours,
      modify: 600,
    )
    assert_equal 4, schedules.length
  end

end
