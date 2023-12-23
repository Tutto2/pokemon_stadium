require_relative "move"

class HypnosisMove < Move

  def self.learn
    new(
      attack_name: :hypnosis,
      type: Types::PSYCHIC,
      pp: 20,
      category: :status,
      precision: 60,
      target: :pokemon_target
      )
  end

  private
  def status_effect
    health_condition_apply(pokemon_target, SleepCondition.get_asleep)
  end
end