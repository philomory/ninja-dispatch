require 'test_helper'

class UserNinjaTest < ActiveSupport::TestCase

  test "a user with three active ninjas shouldn't be able to make another" do
    assert_raises(ActiveRecord::RecordInvalid) do
      Ninja.make(:user => user_with_three_ninjas)
    end
  end

  test "a user with three ninjas who retires one should be able to make a fourth" do
    user = user_with_three_ninjas
    user.ninjas.first.retire!
    assert_nothing_raised(ActiveRecord::RecordInvalid) do
      Ninja.make(:user => user)
    end
  end

  protected
  def user_with_three_ninjas
    user = User.make
    3.times do
      Ninja.make(:user => user)
    end
    return user
  end
  
end
