require_relative "../move"

class BindMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Bind',
      type: Types::NORMAL,
      pp: 15,
      category: :physical,
      precision: 85,
      power: 20
      )
  end

  def secondary_effect
    volatile_status_apply(pokemon_target, BoundStatus.get_bound(attack_name, pokemon))
  end
end
