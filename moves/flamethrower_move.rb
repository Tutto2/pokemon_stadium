require_relative "move"

class FlamethrowerMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(  attack_name: :flamethrower,
          type: Types::FIRE,
          category: :special,
          power: 90
        )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, BurnCondition.get_burn)
  end

  def trigger_chance
    1
  end
end