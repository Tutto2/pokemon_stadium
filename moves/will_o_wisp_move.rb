require_relative "move"

class WillOWispMove < Move
  def self.learn
    new(
      attack_name: :will_o_wisp,
      type: Types::FIRE,
      pp: 15,
      category: :status,
      precision: 85,
      target: 'one_opp'
      )
  end
  
  private
  def status_effect(pokemon_target)
    health_condition_apply(pokemon_target, BurnCondition.get_burn)
  end
end

