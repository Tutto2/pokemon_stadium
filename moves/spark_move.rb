require_relative "move"

class SparkMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: :spark,
      type: Types::ELECTRIC,
      pp: 20,
      category: :special,
      power: 65
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, ParalysisCondition.get_paralyzed)
  end

  def trigger_chance
    0.3
  end
end
