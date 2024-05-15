require_relative "../../move"
require_relative "../../../messenger/messages_pool"
require_relative "../../../messenger/battle_log"

module ProtectionBreak
  def breaks_protection?
    true
  end

  def protect_evaluation(pokemon_target)
    if pokemon_target.is_protected?
      BattleLog.instance.log(MessagesPool.broke_protection_msg(pokemon.name, pokemon_target.name))
      pokemon_target.protection_delete
    end
  end
end