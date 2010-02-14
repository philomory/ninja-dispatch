require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase
  
  test "a new challenge is in_progress" do
    assert_equal 'in_progress', Challenge.make.state
  end
  
  test "confronting a challenge returns the state that's transitioned to" do
    5.times do
      challenge = Challenge.make
      result = challenge.confront
      assert_equal result, challenge.state.intern
    end
  end
  
end
