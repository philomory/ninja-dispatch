class Mission < ActiveRecord::Base
  belongs_to :ninja
  belongs_to :victim, :class_name => "User "#in english, 'has a', but the foreign key belongs here.
  has_many :challenges
  
  attr_accessible :ninja_id, :victim_id, :message

  validates_presence_of :ninja_id, :victim_id
  validate_on_create :ninja_is_available?
  validate_on_create :master_and_victim_different?
  
  after_create :new_challenge
  
  # If a subclass defines a STEPS_TO_FINAL constant, that will be used. 
  # Otherwise, Mission's will be used. Likewise for IMMEDIATE_FAILURE_THRESHOLD.
  STEPS_TO_FINAL = 4
  IMMEDIATE_FAILURE_THRESHOLD = -2
  
  include AASM
  aasm_column :state
  aasm_initial_state :in_progress
  
  aasm_state :in_progress, :after_enter => :new_challenge
  aasm_state :final_stage
  aasm_state :succeeded, :after_enter => :mission_complete
  aasm_state :failed, :after_enter => :mission_failed
  
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
  
  def new_challenge
    # Abort if we already have a challenge going.
    raise ChallengeInProgressError unless current_challenge.nil?
    
    # We have to return on a new record because you can't create
    # an associated record before you've saved the parent record.
    # Instead, the creation of the first Challenge is done in a
    # after_create hook.
    return if new_record?
    
    # Find the first available index.
    index = if self.challenges.empty?
      0
    else
      self.challenges.map {|c| c.index}.max + 1
    end
    
    self.challenges.create :index => index
  end
  
  def step
    return unless self.in_progress?
    self.progress += 1
    self.confront_challenge
    self.fail if self.momentum <= self.class.const_get(:IMMEDIATE_FAILURE_THRESHOLD)
  end
  
  def confront_challenge
    case current_challenge.confront!
    when :success then self.momentum += 1
    when :failure then self.momentum -= 1
    when :no_change # No change   
    end
  end

  def reached_final_stage?
    self.progress >= self.class.const_get(:STEPS_TO_FINAL)
  end
  
  def passed_final_test?
    final_grade = rand(15) + momentum
    return (final_grade >= 8)
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
  
  def master_and_victim_different?
    # Only run *this* validation if the ninja and victim are present;
    # if not, the appropriate validates_presence_of will fail instead.
    if self.ninja.present? and self.victim.present?
      errors.add_to_base("Ninja cannot go on a mission targeting its master") unless (ninja.user != victim)
    end
  end

end
