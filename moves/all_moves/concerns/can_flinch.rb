require_relative "../../move"

module CanFlinch
  def secondary_effect
    volatile_status_apply(pokemon_target, FlinchStatus.get_flinched)
  end

  def trigger_chance
    0.3
  end
end