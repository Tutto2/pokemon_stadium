require_relative "move"

class ThunderWaveMove < Move

  def self.learn
    new(
      attack_name: 'Thunder Wave',
      type: Types::ELECTRIC,
      pp: 20,
      category: :status,
      precision: 90,
      target: 'one_opp'
      )
  end

  private
  def status_effect(pokemon_target)
    if pokemon_target.types.any? { |type| type == Types::ELECTRIC || type == Types::GROUND }
      BattleLog.instance.log(MessagesPool.no_affect_target_msg(pokemon_target.name))
    else
      health_condition_apply(pokemon_target, ParalysisCondition.get_paralyzed)
    end
  end
end
