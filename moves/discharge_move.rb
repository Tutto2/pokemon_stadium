require_relative "move"

class DischargeMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: :discharge,
      type: Types::ELECTRIC,
      pp: 15,
      category: :special,
      power: 80,
      target: 'all_except_self'
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, ParalysisCondition.get_paralyzed)
  end

  def trigger_chance
    0.3
  end
end