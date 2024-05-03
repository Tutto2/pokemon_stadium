require_relative "move"

class ThunderMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Thunder',
      type: Types::ELECTRIC,
      pp: 10,
      category: :special,
      power: 110,
      precision: 70
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, ParalysisCondition.get_paralyzed)
  end

  def trigger_chance
    0.3
  end
end
