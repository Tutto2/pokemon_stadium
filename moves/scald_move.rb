require_relative "move"

class ScaldMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(  attack_name: :scald,
          type: Types::WATER,
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