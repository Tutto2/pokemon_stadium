require_relative "../move"

class ScaldMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Scald',
      type: Types::WATER,
      pp: 15,
      category: :special,
      power: 80
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, BurnCondition.get_burn)
  end

  def trigger_chance
    0.3
  end
end
