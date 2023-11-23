require_relative "../trainer"

class AttackAction < Action
  def initialize(**args) 
    super(priority: args[:action].priority, **args)
  end

  def perform
    current_pokemon = trainer.current_pokemon
    current_pokemon.attack!(self) unless current_pokemon.fainted?
  end
end