class Mission < ActiveRecord::Base
  belongs_to :ninja
  belongs_to :victim, :class_name => "User "#in english, 'has a', but the foreign key belongs here.
  
  validates_presence_of :ninja_id, :victim_id
  
  include AASM
  aasm_column :state
  aasm_initial_state :in_progress
  
  aasm_state :in_progress
  aasm_state :succeeded, :enter => :mission_complete
  aasm_state :failed, :enter => :mission_failed
  
  aasm_event :tick, :before => :step, :error => :skip do
    transitions :from => :in_progress, :to => :succeeded, :guard => :finished?
    transitions :from => :in_progress, :to => :in_progress
  end
  
  aasm_event :fail do
    transitions :from => :in_progress, :to => :failed
  end
  
  protected
  def step
    return unless self.in_progress?
    if self.passes_test?
      self.progress += 1
    else
      self.fail
    end
  end
  
  def skip(e)
    raise(e) unless e.is_a?(AASM::InvalidTransition)
  end
  
  def finished?
  end
  
  def mission_complete
  end
  
  def mission_failed
  end
  
  def passes_test?
    return !!self.test
  end
  
  def test
    return rand(10) == 0
  end

end
