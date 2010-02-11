require 'test_helper'

class MissionTest < ActiveSupport::TestCase

  test "a new mission should be in_progress" do
    assert Mission.make.in_progress?
  end
  
  test "a mission tick should adjust progress" do
    mission = Mission.make
    assert_different(mission.progress) do
      mission.tick
    end
  end
  
end
