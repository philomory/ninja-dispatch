class Ninja < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :name
  validates_associated :user
  after_validation_on_create :new_ninja_is_always_active
  
  def retire!
    self.active = false
    self.save!
  end
  
  def status
    self.active ? "Active" : "Retired" 
  end
  
  private
  def new_ninja_is_always_active
    self.active = true
  end
  
end
