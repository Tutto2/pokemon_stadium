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
    heat_attacks = %w[
      flame_wheel 
      flare_blitz 
      sacred_fire 
      fusion_flare 
      scald 
      steam_eruption 
      burn_up 
      pyro_ball
      pyroclastic_burst
      scorching_defense
      scorching_sands 
      matcha_gotcha
    ]
    heat_attacks.include?(parameterized_name)
  end

  def sound_based?
    sound_attacks = %w[
      alluring_voice
      boomburst
      bug_buzz
      clanging_scales
      clangorus_soul
      disarming_voice
      hyper_voice
      metal_sound
      perish_song
      roar
      snore
      uproar
    ]
    sound_attacks.include?(parameterized_name)
  end

  def goes_through_substitute?
    ignore_substitute_attacks = %w[
      attract
      curse
      encore
      psych_up
      swagger
      transform
      whirlwind
    ]
    ignore_substitute_attacks.include?(parameterized_name)
  end

  def goes_through_protection?
    ignore_protection_attacks = %w[
      curse
      future_sight
      psych_up
      roar
      perish_song
      transform
      copycat
      metronome
    ]
    ignore_protection_attacks.include?(parameterized_name)
  end

  def cant_be_copied?
    copycat_uncallable_moves = %w[
      copycat
      counter
      endure
      focus_punch
      metronome
      pyroclastic_burst
      protect
      roar
      scorching_defense
      shell_trap
      struggle
      spiky_shield
      transform
    ]
    copycat_uncallable_moves.include?(parameterized_name)
  end

  def cant_be_use_by_metronome?
    metronome_uncallable_moves = %w[
      body_press
      breaking_swipe
      clangorous_soul
      copycat
      counter
      destiny_bond
      detect
      double_iron_bash
      endure
      feint
      focus_punch
      make_it_rain
      metronome
      mirror_coat
      obstruct
      pyroclastic_burst
      protect
      scorching_defense
      shell_trap
      sleep_talk
      snore
      spiky_shield
      struggle
      transform
    ]
    metronome_uncallable_moves.include?(parameterized_name)
  end

  def cant_be_use_by_encore?
    encore_uncallable_moves = %w[
      transform
      mirror_move
      struggle
      copycat
      metronome
    ]
    encore_uncallable_moves.include?(parameterized_name)
  end
end