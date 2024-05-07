require_relative "../move"

class SludgeBombMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Sludge Bomb',
      type: Types::POISON,
      pp: 10,
      category: :special,
      power: 90
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, PoisonCondition.get_poisoned)
  end

  def trigger_chance
    0.3
  end
end
