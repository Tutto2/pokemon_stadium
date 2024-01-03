require_relative "volatile_status"

class ConfusionStatus < VolatileConditions
  def self.get_confused
    new(
      name: :confused, 
      duration: rand(1..4)
      )
  end

  def unable_to_attack?
    return true if (rand < 0.33)
    false
  end
end