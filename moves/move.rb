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

  attr_reader :attack_name, :precision, :power, :priority, :pokemon, :targets, :target
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

    assing_target if target.nil?
  end
  
  def assing_target
    @target = category == :status ? 'self' : 'one_opp'
  end

  def perform_attack(user, targets)
    @pokemon = user
    @targets = targets

    return BattleLog.instance.log(MessagesPool.no_pp_during_attack(pokemon.name, attack_name)) if pp <= 0
    return perform_attack_with_trigger if has_trigger?

    BattleLog.instance.log(MessagesPool.attack_being_used_msg(pokemon.name, self))
    return attack_failed! if targets.all?(&:fainted?)

    reassing_fainted_target
    atk_performed
    evaluate_special_perform
  end

  def perform_attack_with_trigger
    return trigger_perform unless pokemon.metadata[:waiting].nil?

    additional_action(pokemon)
    @pokemon.init_whole_turn_action
  end

  def additional_action(pokemon); end

  def trigger_perform
    return trigger_perform_fail_msg unless trigger(pokemon)
    
    BattleLog.instance.log(MessagesPool.attack_being_used_msg(pokemon.name, self))
    atk_performed
    execute
  end

  def reassing_fainted_target
    return if targets.size == 1
    @targets.delete_if { |tar| tar.fainted? }
  end

  def atk_performed
    @pp -= 1 if pokemon.metadata[:turn].nil?
  end

  def evaluate_special_perform
    if has_several_turns?
      action_per_turn 
    elsif return_dmg?
      return_dmg_effect
    elsif action_for_other_turn? && no_pending_action?
      handle_additional_action
    else 
      execute
    end
  end

  def no_pending_action?
    pokemon.trainer.data[:pending_action].nil?
  end
  
  def handle_additional_action
    additional_action(pokemon)
    handle_in_other_turn
  end

  def return_dmg_effect
    return unless triggered?
    
    # CONTINUE...
    if type == Types::FIGHTING && pokemon_target.types.any? { |type| type == Types::GHOST }
      BattleLog.instance.log(MessagesPool.immunity_msg(pokemon_target.name))
    else
      perform_dmg(dmg)
    end
    pokemon.reinit_metadata(self)
  end

  def execute
    return attack_failed! if !pokemon_target.metadata[:invulnerable].nil? && pokemon_target == target
    return attack_failed! unless hit_chance

    effectiveness_message if !protected?

    (strikes_count ? perform_multistrike : action) if effect != 0 || category == :status

    end_of_execution
    pokemon.trainer.battlefield.attack_list["#{pokemon.name}"] = self.dup
  end

  def attack_failed!
    BattleLog.instance.log(MessagesPool.attack_failed_msg)
    pokemon.reinit_metadata(self)
  end
  
  def end_of_execution
    pokemon.reinit_metadata(self)
    return if effect == 0 && category != :status

    end_of_action_message
    post_effect(pokemon) if has_post_effect?
  end

  def additional_move; end

  def no_remaining_pp?
    pp <= 0
  end

  def action_per_turn
    pokemon.init_several_turn_attack 

    case pokemon.metadata[:turn]
    when 1 then first_turn_action
    when 2 then second_turn_action
    when 3 then third_turn_action
    when 4 then fourth_turn_action
    when 5 then fifth_turn_action
    end

    pokemon.count_attack_turns
  end

  def hit_chance
    return true if precision.nil?
    if !pokemon_target.metadata.nil?
      return true if pokemon_target.metadata[:post_effect] == "vulnerable"
    end

    chance = rand(0..100)
    if (@category == :status && precision < chance) || (@category != :status && (precision * pokemon.acc_value * pokemon_target.evs_value ) < chance)
      attack_failed!
      false
    else
      true
    end
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
      return protected_itself if !(target == 'self') && protected?
      return BattleLog.instance.log(MessagesPool.substitute_immune_msg(pokemon_target.name, attack_name)) if !pokemon_target.volatile_status[:substitute].nil? && !(pokemon == target)
      status_effect
    else
      damage_effect
    end
  end

  def status_effect; end

  def damage_effect
    damage_calculation(effect)
  end

  def health_condition_apply(target, condition)
    target.types.each do |target_type|
      condition.immune_type.each do |immune_type|
        return BattleLog.instance.log(MessagesPool.condition_apply_fail_msg(target.name, condition.name)) if target_type == immune_type
      end
    end
    if target == 'self' || target.health_condition.nil?
      target.health_condition = condition
      BattleLog.instance.log(MessagesPool.condition_apply_msg(target.name, condition.name))
    else
      attack_failed! if category == :status
    end
  end

  def volatile_status_apply(target, status)
    if target.volatile_status[status.name].nil?
      status_apply_msg(status.name)
      target.volatile_status[status.name] = status
    else
      attack_failed! if category == :status
    end
  end

  def status_apply_msg(status)
    case status
    when :confused 
      tar = attack_name == :outrage ? pokemon.name : pokemon_target.name
      BattleLog.instance.log(MessagesPool.confusion_apply(tar))
    when :cursed then BattleLog.instance.log(MessagesPool.curse_apply(pokemon.name, pokemon_target.name)) 
    when :infatuated then BattleLog.instance.log(MessagesPool.infatuation_apply(pokemon_target.name)) 
    when :seeded then BattleLog.instance.log(MessagesPool.seed_apply(pokemon_target.name))
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