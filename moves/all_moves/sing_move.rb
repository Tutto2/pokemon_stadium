require_relative "move"

class SingMove < Move

  def self.learn
    new(
      attack_name: 'Sing',
      type: Types::NORMAL,
      pp: 15,
      category: :status,
      precision: 55,
      target: 'one_opp'
      )
  end

  private
  def status_effect(pokemon_target)
    health_condition_apply(pokemon_target, SleepCondition.get_asleep)
  end
end
