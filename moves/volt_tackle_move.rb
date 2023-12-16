require_relative "move"

class VoltTackleMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include HasRecoil

  def self.learn
    new(
      attack_name: :volt_tackle,
      type: Types::ELECTRIC,
      pp: 15,
      category: :physical,
      power: 120
      )
  end

  def recoil_factor
    1.0/3.0
  end

  def secondary_effect
    health_condition_apply(pokemon_target, ParalysisCondition.get_paralyzed)
  end

  def trigger_chance
    0.3
  end
end