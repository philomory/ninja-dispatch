require 'test_helper'

class MissionTest < ActiveSupport::TestCase

  test "a new mission should be in_progress" do
    assert Mission.make.in_progress?
  end
  
  test "a new mission should have a progress of 0" do
    assert Mission.make.progress.zero?
  end
  
  test "a mission tick should adjust progress or cause failure" do
    10.times do
      mission = Mission.make
      mission.tick
      assert (mission.progress == 1 or mission.failed?)
    end
  end
  
  test "a mission should either succeed or fail by the 3rd tick" do
    5.times do
      mission = Mission.make
      3.times do
        mission.tick
      end
      assert (mission.succeeded? or mission.failed?)
    end
  end
  
  test "a successful mission should remain successful after a tick" do
    mission = Mission.make
    mission.state = 'succeeded'
    10.times do
      mission.tick
      assert mission.succeeded?
    end
  end
  
  test "a failed mission should remain failed after a tick" do
    mission = Mission.make
    mission.state = 'failed'
    10.times do
      mission.tick
      assert mission.failed?
    end
  end
  
  
end
