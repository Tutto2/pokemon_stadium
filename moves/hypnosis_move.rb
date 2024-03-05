require_relative "move"

class HypnosisMove < Move

  def self.learn
    new(
      attack_name: :hypnosis,
      type: Types::PSYCHIC,
      pp: 20,
      category: :status,
      precision: 60,
      target: 'one_opp'
      )
  end

  private
  def status_effect(pokemon_target)
    health_condition_apply(pokemon_target, SleepCondition.get_asleep)
  end
end