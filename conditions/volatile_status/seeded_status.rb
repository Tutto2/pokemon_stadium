require_relative "volatile_status"

class SeededStatus < VolatileStatus
  def self.get_seeded(opponent)
    new(
      name: :seeded,
      data: opponent
      )
  end

  def dmg_effect(pokemon)
    value = (pokemon.hp_total) * ( 1.0 / 8.0 )
    BattleLog.instance.log(MessagesPool.seeded_dmg_msg(pokemon.name, value.to_i))
    pokemon.hp.decrease(value.to_i)
    data.current_pokemons.hp.increase(value.to_i)
  end
end