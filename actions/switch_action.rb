require_relative "../trainer"

class SwitchAction < Action
  def initialize(**args) 
    super(priority: 6, **args)
  end
  
  def perform
    next_pokemon = behaviour
    puts "#{next_pokemon.name} got out to battle!"
    @trainer.current_pokemon = next_pokemon
    puts
  end
end