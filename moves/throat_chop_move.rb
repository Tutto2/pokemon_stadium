require_relative "move"

class ThroatChopMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: :throat_chop,
      type: Types::DARK,
      pp: 15,
      category: :physical,
      power: 80
      )
  end

  def secondary_effect
    pokemon_target.cant_emit_sound
  end
end