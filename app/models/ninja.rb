class Ninja < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :name
  validates_associated :user
  after_validation_on_create :new_ninja_is_always_active
  
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
  
  private
  def new_ninja_is_always_active
    self.active = true
  end
  
end
