require_relative "move"

class SludgeBombMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(  attack_name: :sludge_bomb,
          type: Types::POISON,
          category: :special,
          power: 90
        )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, PoisonCondition.get_poisoned)
  end

  def trigger_chance
    1
  end
end