require_relative "../trainer"
require "pry"

class AttackAction < Action
  def initialize(**args) 
    super(priority: args[:behaviour].priority, **args)
  end

  def perform
    current_pokemon = trainer.current_pokemon
    condition = current_pokemon.health_condition
    if condition == :frozen
      if condition.free_chance? || self.behaviour.can_defrost?(self.behaviour.attack_name)
        puts "#{current_pokemon.name} got thawed out"
        current_pokemon.health_condition = nil
      end
    end
    current_pokemon.attack!(self) unless current_pokemon.fainted?
  end

  def enqueueable
    [extra_action, self].compact
  end

  def extra_action
    additional_move = behaviour.additional_move
    if additional_move
      self.dup.override_behaviour!(additional_move)
    end
  end

  def override_behaviour!(behaviour)
    @behaviour = behaviour
    @priority = behaviour.priority
    self
  end
end