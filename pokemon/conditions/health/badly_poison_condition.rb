require_relative "health_conditions"

class BadlyPoisonCondition < HealthConditions
  def self.get_badly_poisoned
    new(  
      name: :badly_poisoned, 
      immune_type: [Types::POISON, Types::STEEL]
      )
  end

  def initialize(name:, immune_type:)
    @name = name
    @immune_type = immune_type
    
    init_count
  end

  def dmg_effect(pokemon)
    value = (pokemon.hp_total) * ( ( 1.0 + turn ) / 16.0 )
    BattleLog.instance.log(MessagesPool.poison_dmg_msg(pokemon.name, value.to_i))
    pokemon.hp.decrease(value.to_i)
  end
end