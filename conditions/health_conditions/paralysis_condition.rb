require_relative "health_conditions"

class ParalysisCondition < HealthConditions
  def self.get_paralyzed
    new(  
      name: :paralyzed, 
      immune_type: [Types::ELECTRIC]
      )
  end

  def unable_to_move
    return true if rand < 0.25
    false
  end
end