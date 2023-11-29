require_relative "health_conditions"

class BurnCondition < HealthConditions
  def self.get_burn
    new(  
      name: :burned, 
      inmune_type: Types::FIRE
      )
  end

  def dmg_effect(pokemon)
    puts "#{pokemon.name} is hurt by its burn!"
    value = (pokemon.hp_total) * ( 1.0 / 16.0 )
    pokemon.hp.decrease(value.to_i)
  end
end