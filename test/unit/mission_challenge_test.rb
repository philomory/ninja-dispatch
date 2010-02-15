require 'test_helper'

class MissionChallengeTest < ActiveSupport::TestCase
  
  test "a new mission starts with a single, in_progress challenge" do
    mission = Mission.make
    assert_equal 1, mission.challenges.count
    assert_equal 'in_progress', mission.challenges.first.state
  end
  
  test "a successful challenge should increment momentum" do
    mission = Mission.make
    Challenge.any_instance.stubs(:calculate_result).returns(:success)
    assert_difference('mission.momentum') do
      mission.tick
    end
  end
  
  test "a failed challenge should decrement momentum" do
    mission = Mission.make
    Challenge.any_instance.stubs(:calculate_result).returns(:failure)
    assert_difference('mission.momentum',-1) do
      mission.tick
    end
  end
  
  test "a no_change challenge should not alter momentum" do
    mission = Mission.make
    Challenge.any_instance.stubs(:calculate_result).returns(:no_change)
    assert_no_difference('mission.momentum') do
      mission.tick
    end
  end
  
  test 'a mission should fail after IMMEDIATE_FAILURE_THRESHOLD failed challenges' do
    mission = Mission.make
    Challenge.any_instance.stubs(:calculate_result).returns(:failure)
    Mission::IMMEDIATE_FAILURE_THRESHOLD.abs.times do
      mission.tick
    end
    assert mission.failed?
  end
  
  test "a mission should reach final_stage after STEPS_TO_FINAL successful challenges" do
    mission = Mission.make
    Challenge.any_instance.stubs(:calculate_result).returns(:success)
    Mission::STEPS_TO_FINAL.times do
      mission.tick
    end
    assert mission.final_stage?
  end
  
  
end