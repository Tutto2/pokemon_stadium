require_relative "move"

class ToxicMove < Move

  def self.learn
    new(
      attack_name: 'Toxic',
      type: Types::POISON,
      pp: 10,
      category: :status,
      precision: 90,
      target: 'one_opp'
      )
  end

  private
  def status_effect(pokemon_target)
    health_condition_apply(pokemon_target, BadlyPoisonCondition.get_badly_poisoned)
  end
end
