require_relative "move"

class FlamethrowerMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Flamethrower',
      type: Types::FIRE,
      pp: 15,
      category: :special,
      power: 90
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, BurnCondition.get_burn)
  end

  def trigger_chance
    0.1
  end
end
