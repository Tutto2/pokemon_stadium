require_relative "../move"
require_relative "../../messages_pool"
require_relative "../../battle_log"

module ProtectionBreak
  def breaks_protection?
    true
  end

  def protect_evaluation
    return execute unless pokemon_target.is_protected?

    BattleLog.instance.log(MessagesPool.broke_protection_msg(pokemon.name, pokemon_target.name))
    pokemon_target.protection_delete
    execute
  end
end