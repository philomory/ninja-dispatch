module NinjaDispatchErrors
  class Error < StandardError; end
  class ChallengeError < Error; end
  class ChallengeCompleteError < ChallengeError; end
  class MissionError < Error; end
  class ChallengeInProgressError < MissionError; end
end

class ActiveRecord::Base
  include NinjaDispatchErrors
end