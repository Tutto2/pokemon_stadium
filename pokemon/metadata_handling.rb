require_relative "pokemon"

module MetadataHandling
  def increase_crit_stage(stages)
    @metadata[:crit_stage] += stages
  end

  def init_several_turn_attack
    @metadata[:turn] = 1
  end

  def count_attack_turns
    @metadata[:turn] += 1
  end

  def is_attacking?
    !metadata[:turn].nil?
  end

  def defense_curl_power_up
    @metadata[:defense_curl] = "Power up"
  end

  def has_power_up?
    !metadata[:defense_curl].nil?
  end  

  def init_whole_turn_action
    @metadata[:harm] = 0
  end

  def harm_recieved
    return if metadata[:harm].nil?
    @metadata[:harm] += 1
  end

  def got_harm?
    metadata[:harm] == 1
  end

  def has_banned_attack?
    !metadata[:banned].nil?
  end

  def is_protected
    @metadata[:protected] = "Protect"
  end

  def is_protected?
    metadata[:protected] == "Protect"
  end

  def protection_delete
    metadata.delete(:protected)
  end

  def make_invulnerable(source)
    @metadata[:invulnerable] = source
  end

  def vulnerable_again
    metadata.delete(:invulnerable)
  end

  def add_consecutive_hits
    @metadata[:consecutive_hits] ||= 0
    @metadata[:consecutive_hits] += 1
  end

  def cant_emit_sound
    @metadata[:mute] = 0
  end

  def evaluate_mute_turn
    return if metadata[:mute].nil?
    metadata[:mute] == 2 ? @metadata.delete(:mute) : @metadata[:mute] += 1
  end

  def sound_based_attack_blocked?(attack)
    return if metadata[:mute].nil?
    attack.sound_based?
  end

  def successful_perform
    @metadata[:perform] = "success"
  end

  def was_successful?
    metadata[:perform] == "success"
  end

  def reinit_metadata
    exceptions = [:crit_stage, :defense_curl, :turn, :protected, :consecutive_hits, :invulnerable]
    @metadata.keep_if { |key, _| exceptions.include?(key) }
  end

  def reinit_all_metadata
    @metadata = {crit_stage: 0}
  end
end