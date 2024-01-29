require_relative "health_conditions"

class BurnCondition < HealthConditions
  def self.get_burn
    new(  
      name: :burned, 
      immune_type: [Types::FIRE]
      )
  end

  def dmg_effect(pokemon)
    value = (pokemon.hp_total) * ( 1.0 / 16.0 )
    BattleLog.instance.log(MessagesPool.burn_dmg_msg(pokemon.name, value.to_i))
    pokemon.hp.decrease(value.to_i)
  end
end