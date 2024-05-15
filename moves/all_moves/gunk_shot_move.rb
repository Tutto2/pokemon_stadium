require_relative "../move"

class GunkShotMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Gunk Shot',
      type: Types::POISON,
      pp: 5,
      category: :physical,
      power: 120,
      precision: 80
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, PoisonCondition.get_poisoned)
  end

  def trigger_chance
    0.3
  end
end
