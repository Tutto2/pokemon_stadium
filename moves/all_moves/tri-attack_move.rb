require_relative "move"

class TriAttackMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Tri Attack',
      type: Types::NORMAL,
      pp: 10,
      category: :special,
      power: 80
      )
  end

  def secondary_effect
    freeze = FreezeCondition.get_freeze
    burn = BurnCondition.get_burn
    paralysis = ParalysisCondition.get_paralyzed
    possible_effects = [freeze, burn, paralysis]
    return health_condition_apply(pokemon_target, possible_effects.sample)
  end

  def trigger_chance
    0.2
  end
end
