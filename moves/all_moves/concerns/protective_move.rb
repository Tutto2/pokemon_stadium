require_relative "../../move"
require_relative "../../../messenger/messages_pool"
require_relative "../../../messenger/battle_log"

module ProtectiveMove
  def chance_of_succeed
    count = pokemon.metadata[:protection_consecutive_uses].to_i

    (1.0 / 3.0) ** count
  end

  def status_effect(pokemon_target)
    if rand < chance_of_succeed
      pokemon.is_protected(parameterized_name.to_sym)
      @successful = true
    else 
      BattleLog.instance.log(MessagesPool.attack_failed_msg)
      @successful = false
    end
  end

  def post_effect(pokemon)
    successful ? pokemon.add_protection_consecutive_uses : pokemon.metadata.delete(:protection_consecutive_uses) 
    BattleLog.instance.log("consecutive uses: #{pokemon.metadata[:protection_consecutive_uses]}")
  end
end
