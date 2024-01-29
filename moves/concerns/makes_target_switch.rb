require_relative "../move"
require_relative "../../messages_pool"
require_relative "../../battle_log"

module MakesTargetSwitch
  def status_effect
    target_switch
  end

  def target_switch
    target_team = pokemon_target.trainer.team.reject { |pok| pok == pokemon_target }
    return BattleLog.instance.log(MessagesPool.switch_failed_alert(pokemon_target.trainer.name, attack_name)) if target_team.all?(&:fainted?)
    
    pokemon_target.stats.each do |stat|
      stat.reset_stat
    end
    pokemon_target.reinit_all_metadata
    pokemon_target.reinit_volatile_condition

    pokemon_target.trainer.current_pokemon = target_team.sample
    BattleLog.instance.log(MessagesPool.switch_action_msg(pokemon_target.trainer.current_pokemon.name))
  end
end