require_relative "move"

class SingMove < Move

  def self.learn
    new(
      attack_name: :sing,
      type: Types::NORMAL,
      pp: 15,
      category: :status,
      precision: 55,
      target: :pokemon_target
      )
  end

  private
  def status_effect
    health_condition_apply(pokemon_target, SleepCondition.get_asleep)
  end
end