require_relative "../../move"

module SpecialFeatures
  def has_trigger?
    false
  end

  def has_several_turns?
    false
  end

  def action_for_other_turn?
    false
  end

  def can_defrost?
    heat_attacks = %i[
      flame_wheel 
      flare_blitz 
      sacred_fire 
      fusion_flare 
      scald 
      steam_eruption 
      burn_up 
      pyro_ball
      scorching_sands 
      matcha_gotcha
    ]
    heat_attacks.include?(attack_name)
  end

  def sound_based?
    sound_attacks = %i[
      boomburst
      clanging_scales
      clangorus_soul
      perish_song
      metal_sound
      hyper_voice
    ]
    sound_attacks.include?(attack_name)
  end

  def goes_through_protection?
    ignore_protection_attacks = %i[
      curse
      future_sight
      psych_up
      roar
      perish_song
      transform
      copycat
      metronome
    ]
    ignore_protection_attacks.include?(attack_name)
  end

  def cant_be_copied?
    copycat_uncallable_moves = %i[
      copycat
      counter
      endure
      focus_punch
      metronome
      protect
      roar
      shell_trap
      struggle
      spiky_shield
      transform
    ]
    copycat_uncallable_moves.include?(attack_name)
  end
end