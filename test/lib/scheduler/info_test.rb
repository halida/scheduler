require 'test_helper'

class Scheduler::InfoTest < ActiveSupport::TestCase
  test "info returns expected structure" do
    user = User.new(timezone: 'UTC')
    info = Scheduler::Info.get(user)

    assert info.key?(:environment)
    assert info.key?(:version)
    assert info.key?(:time)
    assert info[:time].key?(:system)
    assert info[:time].key?(:rails)
    assert info[:time].key?(:user)
  end

  test "info returns correct environment" do
    user = User.new(timezone: 'UTC')
    info = Scheduler::Info.get(user)

    assert_equal Rails.env, info[:environment][:rails]
  end

  test "info returns correct versions" do
    user = User.new(timezone: 'UTC')
    info = Scheduler::Info.get(user)

    assert_equal RUBY_VERSION, info[:version][:ruby]
    assert_equal Rails::VERSION::STRING, info[:version][:rails]
  end

  test "info handles user timezone correctly" do
    user = User.new(timezone: 'Asia/Shanghai')
    info = Scheduler::Info.get(user)

    assert_equal 'Asia/Shanghai', info[:time][:user][:zone]
    assert_equal Time.now.in_time_zone('Asia/Shanghai').to_s, info[:time][:user][:time].to_s
  end
end
