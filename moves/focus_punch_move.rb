require_relative "move"

class FocusPunchMove < Move
  include BasicPhysicalAtk
  include WholeTurnAction
  include HasTrigger

  def self.learn
    new(  attack_name: :focus_punch,
          type: Types::FIGHTING,
          category: :physical,
          priority: -3,
          power: 150
        )
  end

  def additional_move
    ExtremeSpeedMove.learn
  end

  private

  def init_act(pokemon)
    puts "#{pokemon.name} is focusing."
    pokemon.init_whole_turn_action
    puts
  end

  def trigger(pokemon)
    !pokemon.got_harm?
  end
end