require_relative "../move"

class HeatWaveMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Heat Wave',
      type: Types::FIRE,
      pp: 10,
      category: :special,
      power: 95,
      precision: 90,
      target: 'all_opps'
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, BurnCondition.get_burn)
  end

  def trigger_chance
    0.1
  end
end