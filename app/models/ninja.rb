class Ninja < ActiveRecord::Base
  belongs_to :user
  has_many :missions
  validates_presence_of :user_id, :name
  validate_on_create :user_has_room?
  before_validation_on_create :new_ninja_is_always_active
  attr_readonly :user_id
  
  def self.find_active(id, options={})
    self.with_scope(options) do
      self.find(id, :conditions => {:active => true})
    end
  end
  
  def self.find_inactive(id, options={})
    self.with_scope(options) do
      self.find(id, :conditions => {:active => false})
    end
  end
  
  def retire!
    self.active = false
    self.save!
  end
  
  def status
    self.active ? "Active" : "Retired" 
  end
  
  def current_mission
    self.missions.find(:first, :conditions => {:state => 'in_progress'})
  end
  
  def available?
    self.current_mission.nil?
  end
  
  private
  def new_ninja_is_always_active
    self.active = true
  end
  
  def user_has_room?
    # Only run *this* validation if the user is present; if not, the 
    # validates_presence_of :user_id will fail instead.
    if self.user.present?
      errors.add_to_base("Too many ninjas") unless self.user.room_for_more? 
    end
  end
end
