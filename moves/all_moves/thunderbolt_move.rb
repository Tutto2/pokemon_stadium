require_relative "../move"

class ThunderboltMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Thunderbolt',
      type: Types::ELECTRIC,
      pp: 15,
      category: :special,
      power: 90
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, ParalysisCondition.get_paralyzed)
  end

  def trigger_chance
    0.1
  end
end