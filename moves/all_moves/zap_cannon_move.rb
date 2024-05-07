require_relative "../move"

class ZapCannonMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Zap Cannon',
      type: Types::ELECTRIC,
      pp: 5,
      category: :special,
      power: 120,
      precision: 0
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, ParalysisCondition.get_paralyzed)
  end

  def trigger_chance
    1
  end
end
