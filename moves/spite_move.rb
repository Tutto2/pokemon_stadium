require_relative "move"

class SpiteMove < Move
  def self.learn
    new(
      attack_name: :spite,
      type: Types::GHOST,
      pp: 10,
      category: :status
      )
  end

  private
  def status_effect
    previous_action = pokemon_target.trainer.action.behaviour

    if previous_action.is_a?(Move)
      BattleLog.instance.log(MessagesPool.spite_msg(pokemon_target.name, previous_action.attack_name))
      (previous_action.pp -= 4).clamp(0, 40)
    else
      BattleLog.instance.log(MessagesPool.attack_failed_msg)
    end
  end
end