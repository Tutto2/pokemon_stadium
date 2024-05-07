require_relative "../move"

class FireSpinMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Fire Spin',
      type: Types::FIRE,
      pp: 15,
      category: :special,
      precision: 85,
      power: 35
      )
  end

  def secondary_effect
    volatile_status_apply(pokemon_target, BoundStatus.get_bound(attack_name, pokemon))
  end
end
