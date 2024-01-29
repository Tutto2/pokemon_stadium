require_relative "../move"
require_relative "../../messages_pool"
require_relative "../../battle_log"

module HpChange
  def lose_hp(target = pokemon, value)
    return BattleLog.instance.log(MessagesPool.attack_failed_msg) if target.hp_value <= value
    target.hp.decrease(value.to_i)
    BattleLog.instance.log(MessagesPool.lose_hp_msg(target, value.to_i))
    pokemon.successful_perform
  end

  def gain_hp(target = pokemon, value)
    initial_hp = target.hp_value
    return BattleLog.instance.log(MessagesPool.no_hp_effect_msg(target.name)) if initial_hp.to_i == target.hp_total.to_i
    target.hp.increase(value).to_i
    hp_difference = target.hp_value - initial_hp
    BattleLog.instance.log(MessagesPool.recover_msg(target.name, hp_difference))
    pokemon.successful_perform
  end

  private
  def value; end
end