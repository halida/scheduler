require 'test_helper'

class Scheduler::LibTest < ActiveSupport::TestCase

  test "get_token" do
    token = Scheduler::Lib.get_token

    assert_equal 32, token.length
  end

end
