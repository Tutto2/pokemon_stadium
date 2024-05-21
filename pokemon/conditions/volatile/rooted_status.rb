require_relative "volatile_status"

class RootedStatus < VolatileStatus
  def self.get_rooted
    new(
      name: :rooted
      )
  end

  def heal_effect(pokemon)
    value = (pokemon.hp_total) * ( 1.0 / 16.0 )
    BattleLog.instance.log(MessagesPool.rooted_heal_msg(pokemon.name))
    pokemon.hp.increase(value.to_i)
  end
end