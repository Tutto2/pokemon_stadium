require_relative "../../move"

module SpecialFeatures
  def parameterized_name
    name = attack_name.gsub(/[\s-]+/, "_")
    name.downcase
  end

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
      scorching_sands 
      matcha_gotcha
    ]
    heat_attacks.include?(parameterized_name)
  end

  def sound_based?
    sound_attacks = %w[
      boomburst
      clanging_scales
      clangorus_soul
      perish_song
      metal_sound
      hyper_voice
      alluring_voice
    ]
    sound_attacks.include?(parameterized_name)
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
      protect
      roar
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
      protect
      shell_trap
      sleep_talk
      snore
      spiky_shield
      struggle
      transform
    ]
    metronome_uncallable_moves.include?(parameterized_name)
  end
end