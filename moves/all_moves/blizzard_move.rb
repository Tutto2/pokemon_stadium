require_relative "../move"

class BlizzardMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Blizzard',
      type: Types::ICE,
      pp: 5,
      category: :special,
      power: 110,
      precision: 70,
      target: 'all_opps'
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, FreezeCondition.get_freeze)
  end

  def trigger_chance
    0.1
  end
end
