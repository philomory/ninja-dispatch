require 'test_helper'

class MissionTest < ActiveSupport::TestCase

  test "a new mission without a ninja or a victim should raise" do
    assert_raises(ActiveRecord::RecordInvalid) do
      Mission.make(:ninja => nil)
      Mission.make(:victim => nil)
    end
  end

  test "a new mission should be in_progress" do
    assert Mission.make.in_progress?
  end

  test "a new mission should have a progress of 0" do
    assert Mission.make.progress.zero?
  end

  test "a mission tick should increment progress" do
    mission = Mission.make
    assert_difference('mission.progress') do
      mission.tick
    end
  end
  
  test "a mission in the final stage should succeed or fail in the next tick" do
    mission = Mission.make
    mission.state = 'final_stage'
    mission.tick
    assert ( mission.succeeded? || mission.failed? )
  end

  test "a successful or failed mission should remain the same after a tick" do
    %w{succeeded failed}.each do |state|
      mission = Mission.make
      mission.state = state
      10.times do
        mission.tick
        assert mission.state == state
      end
    end
  end

  test "successful and failed missions should not progress during ticks" do
    %w{succeeded failed}.each do |state|
      mission = Mission.make
      mission.state = state
      10.times do
        assert_no_difference('mission.progress') do
          mission.tick
        end
      end
    end
  end



end
