require 'test_helper'

class NinjaMissionTest < ActiveSupport::TestCase
  
  test "a ninja with an in_progress mission should't be able to start another one" do
    ninja = Ninja.make
    Mission.make(:ninja => ninja)
    assert_raises(ActiveRecord::RecordInvalid) do
      Mission.make(:ninja => ninja)
    end
  end
  
  test "a ninja whose mission is over should be able to start another one" do
    ninja = Ninja.make
    mission = Mission.make(:ninja => ninja)
    %w{succeeded failed}.each do |state|
      mission.state = state
      mission.save
      assert_nothing_raised(ActiveRecord::RecordInvalid) do
        mission = Mission.make(:ninja => ninja)
      end
    end
  end
  
end