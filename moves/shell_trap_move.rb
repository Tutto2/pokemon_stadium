require_relative "move"

class ShellTrapMove < Move
  include BasicSpecialAtk
  include HasAdditionalAction
  include HasTrigger

  def self.learn
    new(  attack_name: :shell_trap,
          type: Types::FIRE,
          category: :special,
          priority: -3,
          power: 150
        )
  end

  def additional_action
    Action.new(
      action_type: :additional_action,
      priority: 6,
      action: set_trigger(pokemon),
      speed: self.speed
    )
  end

  private

  def set_trigger(pokemon)
    puts "#{pokemon.name} set a shell trap."
    pokemon.init_whole_turn_action
    puts
  end

  def trigger(pokemon)
    pokemon.got_harm?
  end
end