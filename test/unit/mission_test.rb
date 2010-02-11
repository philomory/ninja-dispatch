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
  
  test "a mission tick should adjust progress or cause failure" do
    results = []
    10.times do
      mission = Mission.make
      mission.tick
      results << mission
    end
    assert results.all? {|mission| mission.progress == 1 or mission.failed?}
  end
  
  test "a mission should either succeed or fail by the 3rd tick" do
    results = []
    5.times do
      mission = Mission.make
      3.times do
        mission.tick
      end
      results << mission
    end
    assert results.all? {|mission| mission.succeeded? or mission.failed? }
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
