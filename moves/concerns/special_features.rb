require_relative "../move"

module SpecialFeatures
  def has_trigger?
    false
  end

  def has_several_turns?
    false
  end

  def can_select_target?
    false
  end

  def action_for_other_turn?
    false
  end

  def can_defrost?
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
    heat_attacks.include?(attack_name)
  end

  def sound_based?
    sound_attacks = [
      :boomburst,
      :clanging_scales,
      :clangorus_soul
    ]
    sound_attacks.include?(attack_name)
  end

  def goes_through_protection?
    ignore_protection_attacks = [
      :curse,
      :future_sight
    ]
    ignore_protection_attacks.include?(attack_name)
  end
end