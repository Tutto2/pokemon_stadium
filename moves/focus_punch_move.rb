require_relative "move"

class FocusPunchMove < Move
  include BasicPhysicalAtk
  include HasPriorityEffect
  include HasTrigger

  def self.learn
    new(  attack_name: :focus_punch,
          type: Types::FIGHTING,
          category: :physical,
          priority: -3,
          power: 150
        )
  end

  private
  def prior_effect(pokemon)
    puts "#{pokemon.name} is focusing."
    pokemon.init_whole_turn_action
    puts
  end

  def trigger(pokemon)
    !pokemon.got_harm?
  end
end