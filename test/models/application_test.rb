require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase

  test "all" do
    app = Application.new(
      name: 'Test App',
      description: 'This is a test application'
    )
    assert_equal app.name, app.title
    assert_nil app.token

    app.save!
    assert_equal app.token.length, 32
  end
end
