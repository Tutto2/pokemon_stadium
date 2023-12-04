require_relative "move"

class TriAttackMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(  attack_name: :tri_attack,
          type: Types::NORMAL,
          category: :special,
          power: 80
        )
  end

  def secondary_effect
    freeze = FreezeCondition.get_freeze
    burn = BurnCondition.get_burn
    possible_effects = [burn]
    return health_condition_apply(pokemon_target, possible_effects.sample)
  end

  def trigger_chance
    1
  end
end