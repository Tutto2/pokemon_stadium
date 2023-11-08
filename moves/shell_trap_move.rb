require_relative "move"

class ShellTrapMove < Move
  include BasicSpecialAtk
  include HasPriorityEffect
  include HasTrigger

  def self.learn
    new(  attack_name: :shell_trap,
          type: Types::FIRE,
          category: :special,
          priority: -3,
          power: 150
        )
  end

  private
  def prior_effect(pokemon)
    puts "#{pokemon.name} set a shell trap."
    pokemon.init_whole_turn_action
    puts
  end

  def trigger(pokemon)
    pokemon.got_harm?
  end
end