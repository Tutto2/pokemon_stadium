require_relative "move"

class SacredFireMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: :sacred_fire,
      type: Types::FIRE,
      pp: 5,
      category: :special,
      precision: 95,
      power: 100
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, BurnCondition.get_burn)
  end

  def trigger_chance
    0.5
  end
end