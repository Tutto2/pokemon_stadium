require_relative "volatile_status"

class EncoredStatus < VolatileStatus
  def self.get_encored
    new(
      name: :encored, 
      duration: 3
      )
  end
end