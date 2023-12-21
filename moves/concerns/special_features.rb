require_relative "../move"

module SpecialFeatures
  def has_trigger?
    false
  end

  def has_several_turns?
    false
  end

  def status?
    category == :status
  end

  def can_select_target?
    false
  end

  def can_defrost?(attack)
    heat_attacks = [
      :flame_wheel, 
      :flare_blitz, 
      :sacred_fire, 
      :fusion_flare, 
      :scald, 
      :steam_eruption, 
      :burn_up, 
      :pyro_ball,
      :scorching_sands, 
      :matcha_gotcha
    ]
    return true if heat_attacks.include?(attack)
    false
  end
end