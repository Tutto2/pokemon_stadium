require_relative "../move"

class IceBeamMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Ice Beam',
      type: Types::ICE,
      pp: 10,
      category: :special,
      power: 90
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, FreezeCondition.get_freeze)
  end

  def trigger_chance
    0.1
  end
end