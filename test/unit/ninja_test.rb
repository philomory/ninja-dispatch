require 'test_helper'

class NinjaTest < ActiveSupport::TestCase

  test "a new ninja should be active" do
    assert Ninja.make.active?
  end
  
  test "a ninja created as inactive should end up active anyway" do
    n = Ninja.plan(:active => false)
    assert Ninja.create(n).active?
  end
  
  test "a retired ninja should be inactive" do
    ninja = Ninja.make
    ninja.retire!
    assert !ninja.active?
  end
  
  test "a ninja without a user shouldn't be allowed" do
    assert_raises(ActiveRecord::RecordInvalid) do
      Ninja.make(:user => nil)
    end
  end
  
  test "it should not be possible to change a ninja's user" do
    user = User.make
    ninja = Ninja.make(:user => user)
    ninja.user = User.make
    
    # because attr_readonly only takes effect at the database,
    # not in the model
    ninja.save; ninja.reload
    
    assert_equal user, ninja.user
  end
end
