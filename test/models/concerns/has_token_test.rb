require 'test_helper'

class HasTokenTest < ActiveSupport::TestCase

  test "all" do
    item = Application.new
    assert_nil item.token

    # assign_token after saved
    item.save!
    assert item.token.length, 32
  end
end
