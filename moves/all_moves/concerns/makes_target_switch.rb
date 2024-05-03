require_relative "../move"
require_relative "../../messages_pool"
require_relative "../../battle_log"

module MakesTargetSwitch
  def status_effect(pokemon_target)
    target_switch(pokemon_target)
  end

  def target_switch(pokemon_target)
    target_position = pokemon_target.field_position
    target_team = pokemon_target.trainer.team.reject { |pok| pok == pokemon_target }
    return BattleLog.instance.log(MessagesPool.switch_failed_alert(pokemon_target.trainer.name, attack_name)) if target_team.all?(&:fainted?)
    
    pokemon_target.got_out_of_battle

    new_pok = target_team.sample
    pokemon_target.trainer.battleground.field.positions[target_position] = new_pok
    BattleLog.instance.log(MessagesPool.switch_action_msg(new_pok.name))
  end
end