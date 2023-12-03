require_relative "health_conditions"

class FreezeCondition < HealthConditions
  def self.get_freeze
    new(  
      name: :frozen, 
      immune_type: Types::ICE
      )
  end

  def unable_to_move
    true
  end

  def free_chance?
    return true if 0.2 > rand
    false
  end
end