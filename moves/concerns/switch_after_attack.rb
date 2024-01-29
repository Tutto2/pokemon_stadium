require_relative "../move"
require_relative "../../messages_pool"
require_relative "../../battle_log"

module SwitchAfterAttack
  def unable_to_switch?
    team = pokemon.trainer.team.reject { |pok| pok == pokemon }
    
    team.all?(&:fainted?)
  end

  def status_effect
    switch_effect
  end

  def secondary_effect
    switch_effect
  end

  def switch_effect
    return BattleLog.instance.log(MessagesPool.unable_to_switch_msg(pokemon.trainer.name, pokemon.name)) if unable_to_switch?

    Menu.pokemon_selection_index(pokemon.trainer, pokemon, source: :move).perform
  end
end