require_relative "move"

class ToxicMove < Move

  def self.learn
    new(
      attack_name: :toxic,
      type: Types::POISON,
      pp: 10,
      category: :status,
      precision: 90
      )
  end

  private
  def status_effect
    health_condition_apply(pokemon_target, BadlyPoisonCondition.get_badly_poisoned)
  end
end