require_relative "move"

class FocusPunchMove < Move
  include BasicPhysicalAtk
  include HasAdditionalAction
  include HasTrigger

  def self.learn
    new(  attack_name: :focus_punch,
          type: Types::FIGHTING,
          category: :physical,
          priority: -3,
          power: 150
        )
  end

  def additional_action(pokemon)
    Action.new(
      action_type: :additional_action,
      priority: 6,
      action: set_trigger(pokemon),
      speed: self.speed
    )
  end

  private

  def set_trigger(pokemon)
    puts "#{pokemon.name} is focusing."
    pokemon.init_whole_turn_action
    puts
  end

  def trigger(pokemon)
    !pokemon.got_harm?
  end
end