require_relative "health_conditions"

class PoisonCondition < HealthConditions
  def self.get_poisoned
    new(  
      name: :poisoned, 
      immune_type: [Types::POISON, Types::STEEL]
      )
  end

  def dmg_effect(pokemon)
    value = (pokemon.hp_total) * ( 1.0 / 8.0 )
    puts "#{pokemon.name} is hurt by poison! (#{value.to_i})"
    pokemon.hp.decrease(value.to_i)
  end
end