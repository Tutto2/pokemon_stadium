require_relative "../move"

module HasSecondaryEffect
  private

  def cast_additional_effect
    secondary_effect if rand < trigger_chance
  end

  def secondary_effect; end

  def trigger_chance
    1
  end
end