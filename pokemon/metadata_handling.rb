require_relative "pokemon"

module MetadataHandling
  def increase_crit_stage(stages)
    @metadata[:crit_stage] ||= 0
    @metadata[:crit_stage] += stages
  end

  def init_several_turn_attack
    return if !metadata[:turn].nil?
    @metadata[:turn] = 1
  end

  def count_attack_turns
    return if metadata[:turn].nil?
    @metadata[:turn] += 1
  end

  def is_attacking?
    !metadata[:turn].nil?
  end

  def stat_increase_during_turn(stat)
    @metadata[:stat_increase] = stat
  end

  def was_buffed?
    !metadata[:stat_increase].nil?
  end

  def defense_curl_power_up
    @metadata[:defense_curl] = "Power up"
  end

  def has_power_up?
    !metadata[:defense_curl].nil?
  end  

  def init_whole_turn_action
    @metadata[:waiting] = true
  end

  def harm_recieved(dmg, pokemon)
    @metadata[:harm] = dmg
  end

  def got_harm?
    metadata[:harm] != 0
  end

  def harm_reinit
    metadata[:harm] = 0
  end

  def has_banned_attack?
    !metadata[:banned].nil?
  end

  def is_protected(source)
    @metadata[:protected] = source
  end

  def is_protected?
    !metadata[:protected].nil?
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

  def add_protection_consecutive_uses
    @metadata[:protection_consecutive_uses] ||= 0
    @metadata[:protection_consecutive_uses] += 1
  end

  def made_contact(pokemon)
    @metadata[:touched] = 1
    @metadata[:attacker] = pokemon
  end

  def lose_fire_type
    @metadata[:fire_lost] = Types::FIRE
  end

  def was_touched?
    !metadata[:touched].nil?
  end

  def prevent_emit_sound
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

  def will_survive
    @metadata[:will_survive] = 1
  end

  def reinit_endure
    metadata.delete(:will_survive)
  end

  def successful_perform
    @metadata[:perform] = "success"
  end

  def was_successful?
    metadata[:perform] == "success"
  end

  def reinit_metadata(move)
    exceptions = [:crit_stage, :defense_curl, :turn, :protected, :invulnerable, :harm, :actions, :will_survive, :fire_lost]
    exceptions << :protection_consecutive_uses if move.respond_to?(:chance_of_succeed)
    @metadata.keep_if { |key, _| exceptions.include?(key) }
    @metadata[:harm] = 0
    @metadata[:actions] += 1
  end

  def reinit_all_metadata
    @metadata = {crit_stage: 0, harm: 0, actions: 0}
  end
end