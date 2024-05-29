require_relative "../../move"

module HasPriorityEffect
  private

  def cast_priority_effect
    secondary_effect if rand < trigger_chance
  end

  def priority_effect; end

  def trigger_chance
    1
  end
end