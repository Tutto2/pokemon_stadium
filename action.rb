require_relative "pokemon/pokemon"

class Action
  attr_reader :action_type, :priority, :action
  
  def initialize(action_type: , priority: 0, action: nil, speed: nil)
    @action_type = action_type
    @priority = priority
    @action = action
    @speed = speed
  end

end