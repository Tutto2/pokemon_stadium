require_relative "volatile_status"

class BoundStatus < VolatileStatus
  def self.get_bound(name, user, opponent)
    new(
      name: :bound,
      duration: rand(4..5),
      data: {
        name: name,
        user: user,
        opponent: opponent
      }
    )
  end

  def dmg_effect(pokemon)
    value = (pokemon.hp_total) * ( 1.0 / 8.0 )
    BattleLog.instance.log(MessagesPool.bound_dmg_msg(pokemon.name, data.name, value.to_i))
    pokemon.hp.decrease(value.to_i)
  end

  def wear_off?
    turn == duration || data.user != data.opponent.current_pokemons
  end
end