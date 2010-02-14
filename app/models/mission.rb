class Mission < ActiveRecord::Base
  belongs_to :ninja
  belongs_to :victim, :class_name => "User "#in english, 'has a', but the foreign key belongs here.
  has_many :challenges
  
  
  validates_presence_of :ninja_id, :victim_id
  validate_on_create :ninja_is_available?
  
  # If a subclass defines a STEPS_TO_FINAL constant, that will be
  # used. Otherwise, Mission's will be used.
  STEPS_TO_FINAL = 4
  IMMEDIATE_FAILURE_THRESHOLD = -2
  
  include AASM
  aasm_column :state
  aasm_initial_state :in_progress
  
  aasm_state :in_progress
  aasm_state :final_stage
  aasm_state :succeeded, :enter => :mission_complete
  aasm_state :failed, :enter => :mission_failed
  
  aasm_event :tick, :before => :step, :error => :skip do
    transitions :from => :in_progress, :to => :final_stage, :guard => :reached_final_stage?
    transitions :from => :in_progress, :to => :in_progress
    
    transitions :from => :final_stage, :to => :succeeded, :guard => :passed_final_test?
    transitions :from => :final_stage, :to => :failed
  end
  
  aasm_event :fail do
    transitions :from => [:in_progress,:final_state], :to => :failed
  end
  
  def current_challenge
    self.challenges.find(:first, :conditions => {:state => 'in_progress'})
  end
  
  def ready_for_challenge?
    self.in_progress? and self.current_challenge.nil?
  end
  
  protected
  def step
    return unless self.in_progress?
    self.progress += 1
    self.standard_test
    self.fail if self.momentum <= self.class.const_get(:IMMEDIATE_FAILURE_THRESHOLD)
  end
  
  def standard_test
    case rand(3)
    when 0
      self.momentum += 1
    when 1
      self.momentum -= 1
    when 2
       # No change    
    end
  end

  def reached_final_stage?
    self.progress >= self.class.const_get(:STEPS_TO_FINAL)
  end
  
  def passed_final_test?
  end

  
  def final_test
  end
  
  def mission_complete
  end
  
  def mission_failed
  end
  
  def skip(e)
    raise(e) unless e.is_a?(AASM::InvalidTransition)
  end  
  
  def ninja_is_available?
    # Only run *this* validation if the ninja is present; if not, the 
    # validates_presence_of :ninja_id will fail instead.
    if self.ninja.present?
      errors.add_to_base("Ninja is unavailable") unless self.ninja.available?
    end
  end

end
