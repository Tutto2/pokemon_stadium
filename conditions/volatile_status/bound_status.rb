require_relative "volatile_status"

class BoundStatus < VolatileStatus
  def self.get_bound(name, user)
    new(
      name: :bound,
      duration: rand(4..5),
      data: {
        name: name,
        user: user
      }
    )
  end

  def dmg_effect(pokemon)
    value = (pokemon.hp_total) * ( 1.0 / 8.0 )
    BattleLog.instance.log(MessagesPool.bound_dmg_msg(pokemon.name, data.name, value.to_i))
    pokemon.hp.decrease(value.to_i)
  end

  def wear_off?
    pokemon = data.user
    turn == duration || !(pokemon.trainer.battleground.field.positions.any? { |_, pok| pok == pokemon })
  end
end