require_relative "move"

class FireSpinMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: :fire_spin,
      type: Types::FIRE,
      pp: 15,
      category: :special,
      precision: 85,
      power: 35
      )
  end

  def secondary_effect
    volatile_status_apply(pokemon_target, BoundStatus.get_bound(attack_name, pokemon, pokemon.trainer))
  end
end