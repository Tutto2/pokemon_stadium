require_relative "../trainer"

class SwitchAction < Action
  def initialize(**args) 
    super(priority: 6, **args)
  end
  
  def perform
    next_pokemon = action
    @trainer.current_pokemon = next_pokemon
  end
end