class ChallengeCompleteError < StandardError; end

class Challenge < ActiveRecord::Base
  belongs_to :mission
  validates_presence_of :mission_id, :index
  validates_uniqueness_of :index, :scope => :mission_id
  validate_on_create :mission_is_ready?
  attr_readonly :mission_id, :index
  
  protected
  def mission_is_ready?
    # Only run *this* validation if the mission is present; if not, the 
    # validates_presence_of :mission_id will fail instead.
    if self.mission.present?
      errors.add_to_base("Mission not ready for new challege.") unless self.mission.ready_for_challenge?
    end
  end
  
end
