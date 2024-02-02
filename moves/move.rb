curr_dir = File.dirname(__FILE__)
concerns_path = File.join(curr_dir, '.', 'concerns')
file_paths = Dir.glob(File.join(concerns_path, '*.rb'))

health_conditions_path = File.join(curr_dir, '../conditions', 'health_conditions')
conditions_paths = Dir.glob(File.join(health_conditions_path, '*.rb'))

volatile_status_path = File.join(curr_dir, '../conditions', 'volatile_status')
status_paths = Dir.glob(File.join(volatile_status_path, '*.rb'))

file_paths.each do |file_path|
  require_relative file_path
end
conditions_paths.each do |condition_paths|
  require_relative condition_paths
end
status_paths.each do |status_path|
  require_relative status_path
end
require_relative "../messages_pool"
require_relative "../battle_log"
require_relative "../pokemon/pokemon"
require_relative "../types/type_factory"
require_relative "../actions/menu"
require_relative "../trainer"

class Move
  include DamageFormula
  include SpecialFeatures

  attr_reader :attack_name, :precision, :power, :priority, :pokemon, :pokemon_target, :target
  attr_accessor :category, :type, :secondary_type, :pp, :metadata

  def initialize(attack_name: nil, type: nil, secondary_type: nil, category: nil, precision: 100, power: 0, priority: 0, pp: nil, metadata: nil, target: nil)
    @attack_name = attack_name
    @type = type
    @secondary_type = secondary_type
    @category = category
    @precision = precision
    @power = power
    @priority = priority
    @pp = pp
    @metadata = metadata
    @target = target
  end

  def perform_attack(*pokemons)
    @pokemon, @pokemon_target = pokemons
    @target = determine_target
    return BattleLog.instance.log(MessagesPool.no_pp_during_attack(pokemon.name, attack_name)) if pp <= 0

    if return_dmg?
      return_dmg_effect
    elsif has_trigger?
      perform_attack_with_trigger
    elsif action_for_other_turn? && pokemon.trainer.data[:pending_action].nil?
      additional_action(pokemon)
      handle_in_other_turn
    else 
      perform_normal_attack
    end
  end
  
  def determine_target
    if category == :status && target.nil?
      pokemon
    elsif category != :status || target == :pokemon_target
      pokemon_target
    end
  end

  def return_dmg_effect
    BattleLog.instance.log(MessagesPool.attack_being_used_msg(pokemon.name, self))
    return BattleLog.instance.log(MessagesPool.attack_failed_msg) if target.fainted? || !triggered?

    if type == Types::FIGHTING && pokemon_target.types.any? { |type| type == Types::GHOST }
      BattleLog.instance.log(MessagesPool.immunity_msg(pokemon_target.name))
      pokemon.reinit_metadata(self)
    else
      perform_dmg(dmg)
      pokemon.reinit_metadata(self)
    end
  end

  def perform_attack_with_trigger
    if pokemon.metadata[:waiting].nil?
      additional_action(pokemon)
      @pokemon.init_whole_turn_action
    else
      trigger_perform
    end
  end
  
  def perform_normal_attack
    if has_several_turns?
      action_per_turn 
    elsif hit_chance
      execute
    end
  end

  def execute
    atk_performed
    return BattleLog.instance.log(MessagesPool.attack_failed_msg) if target.fainted?
    return BattleLog.instance.log(MessagesPool.failed_attack_msg) if !pokemon_target.metadata[:invulnerable].nil? && pokemon_target == target

    effectiveness_message if !protected?
    if effect != 0 || category == :status
      strikes_count ? perform_multistrike : action
      end_of_action_message

      pokemon.reinit_metadata(self)
      post_effect(pokemon) if has_post_effect?
    end
  end

  def additional_move; end

  def no_remaining_pp?
    pp <= 0
  end

  private
  attr_reader :pokemon, :pokemon_target, :target

  def additional_action(pokemon); end

  def atk_performed
    BattleLog.instance.log(MessagesPool.attack_being_used_msg(pokemon.name, self))
  end
  
  def trigger_perform
    if trigger(pokemon)
      @pp -= 1
      execute
    else
      BattleLog.instance.log(MessagesPool.attack_failed_msg)
      pokemon.reinit_metadata(self)
    end
  end

  def action_per_turn
    if pokemon.metadata[:turn].nil?
      @pp -= 1
      pokemon.init_several_turn_attack 
    end

    case pokemon.metadata[:turn]
    when 1 then first_turn_action
    when 2 then second_turn_action
    when 3 then third_turn_action
    when 4 then fourth_turn_action
    when 5 then fifth_turn_action
    end

    pokemon.count_attack_turns if !pokemon.metadata[:turn].nil?
  end

  def hit_chance
    @pp -= 1
    return true if precision.nil?
    if !pokemon_target.metadata.nil?
      return true if pokemon_target.metadata[:post_effect] == "vulnerable"
    end

    chance = rand(0..100)
    if (@category == :status && precision < chance) || (@category != :status && (precision * pokemon.acc_value * pokemon_target.evs_value ) < chance)
      failed_attack_messages
      pokemon.reinit_metadata(self) if !pokemon.metadata.nil?
      return false
    else
      return true
    end
  end

  def failed_attack_messages
    BattleLog.instance.log(MessagesPool.attack_being_used_msg(pokemon.name, self))
    BattleLog.instance.log(MessagesPool.attack_failed_msg)
  end

  def effectiveness_message
    effectiveness = effect

    unless self.category == :status
      if effectiveness < 1 && effectiveness > 0
        BattleLog.instance.log(MessagesPool.ineffective_msg)
      elsif effectiveness == 0
        BattleLog.instance.log(MessagesPool.immunity_msg(pokemon_target.name))
      elsif effectiveness > 1
        BattleLog.instance.log(MessagesPool.super_effective_msg)
      else
        BattleLog.instance.log(MessagesPool.effective_msg)
      end
    end
  end

  def effect
    attack_types = [self.type, self.secondary_type].compact
    Types.calc_multiplier( attack_types, pokemon_target.types )
  end

  def protected?
    return true if attack_name == :pain_split && pokemon_target.is_protected?
    return false if !pokemon_target.is_protected? || goes_through_protection? || pokemon_target != target
    true
  end

  def protected_itself
    BattleLog.instance.log(MessagesPool.was_protected_msg(pokemon_target.name))
    protection_harm
  end

  def protection_harm
    return unless pokemon_target.metadata[:protected] == :spiky_shield && category == :physical
  
    damage = (pokemon.hp_total / 8).to_i
    pokemon.hp.decrease(damage)
    BattleLog.instance.log(MessagesPool.spiky_shield_msg(pokemon.name, damage))
  end

  def strikes_count
    false
  end

  def perform_multistrike
    return protected_itself if protected?
    hits = 0
    strikes_count.times do 
      action
      hits += 1
      break if pokemon_target.fainted?
    end
    BattleLog.instance.log(MessagesPool.multi_hit_msg(pokemon_target.name, strikes_count))
  end

  def action
    main_effect
    if pokemon.was_successful?
      pokemon_target.made_contact if category == :physical
      cast_additional_effect
    end
  end
  
  def main_effect
    if status? 
      return protected_itself if !(target == pokemon) && protected?
      return BattleLog.instance.log(MessagesPool.substitute_immune_msg(pokemon_target.name, attack_name)) if !pokemon_target.volatile_status[:substitute].nil? && !(pokemon == target)
      status_effect
    else
      damage_effect
    end
  end

  def status_effect; end

  def damage_effect
    damage_calculation(self, pokemon, pokemon_target, effect)
  end

  def health_condition_apply(target, condition)
    target.types.each do |target_type|
      condition.immune_type.each do |immune_type|
        return BattleLog.instance.log(MessagesPool.condition_apply_fail_msg(target.name, condition.name)) if target_type == immune_type
      end
    end
    if target == pokemon || target.health_condition.nil?
      target.health_condition = condition
      BattleLog.instance.log(MessagesPool.condition_apply_msg(target.name, condition.name))
    else
      BattleLog.instance.log(MessagesPool.attack_failed_msg) if category == :status
    end
  end

  def volatile_status_apply(target, status)
    if target.volatile_status[status.name].nil?
      status_apply_msg(status.name)
      target.volatile_status[status.name] = status
    else
      BattleLog.instance.log(MessagesPool.attack_failed_msg) if category == :status
    end
  end

  def status_apply_msg(status)
    case status
    when :confused 
      target = attack_name == :outrage ? pokemon.name : pokemon_target.name
      BattleLog.instance.log(MessagesPool.confusion_apply(target))
    when :cursed then BattleLog.instance.log(MessagesPool.curse_apply(pokemon.name, pokemon_target.name)) 
    when :infatuated then BattleLog.instance.log(MessagesPool.infatuation_apply(target.name)) 
    when :seeded then BattleLog.instance.log(MessagesPool.seed_apply(target.name))
    when :substitute then BattleLog.instance.log(MessagesPool.substitute_apply(pokemon.name))
    when :bound then BattleLog.instance.log(MessagesPool.bound_apply(pokemon.name))
    when :transformed then BattleLog.instance.log(MessagesPool.transform_apply(pokemon.name, pokemon_target.name))
    end
  end
  
  def cast_additional_effect; end

  def end_turn_action
    pokemon.metadata.delete(:turn)
  end

  def has_post_effect?
    false
  end

  def status?
    category == :status
  end

  def return_dmg?
    false
  end
  
  def drain
    false
  end

  def crit_ratio
    0
  end

  def end_of_action_message
    BattleLog.instance.log(MessagesPool.pok_fainted_msg(pokemon.name)) if pokemon.fainted?
    BattleLog.instance.log(MessagesPool.pok_fainted_msg(pokemon_target.name)) if pokemon_target.fainted?
    BattleLog.instance.log(MessagesPool.final_hp_msg(pokemon_target.name, pokemon_target.hp_value)) if category != :status && !pokemon_target.fainted?
  end
end