require_relative "volatile_status"

class CurseStatus < VolatileStatus
  def self.get_cursed
    new(
      name: :cursed 
      )
  end

  def dmg_effect(pokemon)
    value = (pokemon.hp_total) * ( 1.0 / 4.0 )
    BattleLog.instance.log(MessagesPool.curse_dmg_msg(pokemon.name, value.to_i))
    pokemon.hp.decrease(value.to_i)
  end
end