curr_dir = File.dirname(__FILE__)
move_concerns_path = File.join(curr_dir, '/all_moves', 'concerns')
concerns_paths = Dir.glob(File.join(move_concerns_path, '*.rb'))

health_conditions_path = File.join(curr_dir, '../pokemon/conditions', 'health')
conditions_paths = Dir.glob(File.join(health_conditions_path, '*.rb'))

volatile_status_path = File.join(curr_dir, '../pokemon/conditions', 'volatile')
status_paths = Dir.glob(File.join(volatile_status_path, '*.rb'))

concerns_paths.each do |concern_path|
  require_relative concern_path
end
conditions_paths.each do |condition_paths|
  require_relative condition_paths
end
status_paths.each do |status_path|
  require_relative status_path
end
require_relative "move_finder"
require_relative "../messenger/messages_pool"
require_relative "../messenger/battle_log"
require_relative "../pokemon/pokemon"
require_relative "../types/type_factory"

class Move
  include DamageFormula
  include SpecialFeatures

  attr_reader :attack_name, :precision, :power, :priority, :pokemon, :target
  attr_accessor :category, :type, :secondary_type, :pp, :metadata, :targets

  def initialize(attack_name: nil, type: nil, secondary_type: nil, category: nil, precision: 100, power: 0, priority: 0, pp: nil, metadata: nil, target: nil)
    @attack_name = attack_name
    @parameterized_name = parameterized_name
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

  def parameterized_name
    return if attack_name.nil?
    attack_name.gsub(/[\s-]+/, "_").downcase
  end

  def perform_attack(user, targets)
    @pokemon = user
    @targets = targets
    return if additional_action(pokemon) && !has_trigger?

    return BattleLog.instance.log(MessagesPool.no_pp_during_attack(pokemon.name, attack_name)) if no_remaining_pp?
    if has_trigger? && (pokemon.metadata[:waiting].nil? || !trigger(pokemon))
      return set_trigger if pokemon.metadata[:waiting].nil?
      return trigger_perform_fail_msg
    end

    BattleLog.instance.log(MessagesPool.attack_being_used_msg(pokemon.name, self))
    
    return attack_failed! if targets.empty?
    reassing_fainted_target
    return attack_failed! if targets.all?(&:fainted?) && targets.size > 1
    
    atk_performed
    priority_effect if self.is_a?(HasPriorityEffect)
    evaluate_special_perform
  end

  def no_remaining_pp?
    pp <= 0 unless pp.nil?
  end

  def set_trigger
    @pokemon.init_whole_turn_action
  end  

  def additional_action(pokemon); end

  def reassing_fainted_target
    battle_type = targets[0].trainer.battleground.battle_type

    if targets.size > 1 && targets.any?(&:fainted?)
      targets_trim
    elsif battle_type == 'double' && targets.size == 1
      assing_other_opp if targets[0].fainted? || targets[0].nil?
    end
  end

  def targets_trim
    @targets.delete_if { |tar| tar.fainted? }
  end

  def assing_other_opp
    pok_positions = targets[0].trainer.battleground.field.positions
    fainted_tar = pok_positions.find { |i, pok| pok == targets[0] }
    index = fainted_tar[0]
    teams_mapping = {
      1 => 3,
      3 => 1,
      2 => 4,
      4 => 2
    }

    @targets = [pok_positions[teams_mapping[index]]]
  end

  def attack_failed!
    BattleLog.instance.log(MessagesPool.attack_failed_msg)
    pokemon.reinit_metadata(self)
  end

  def attack_missed!
    BattleLog.instance.log(MessagesPool.attack_missed_msg(pokemon))
    pokemon.reinit_metadata(self)
  end
  
  def atk_performed
    @pp -= 1 if pokemon.metadata[:turn].nil? && !pp.nil?
  end

  def evaluate_special_perform
    if has_several_turns?
      action_per_turn 
    elsif return_dmg?
      return_dmg_effect
    elsif action_for_other_turn? && no_pending_action?
      handle_additional_action(targets[0])
    else 
      execute
      post_effect(pokemon, targets) if has_post_effect?
    end
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

  def return_dmg_effect
    return attack_failed! unless triggered?

    @targets = [pokemon.metadata[:attacker]]
    assing_other_opp if targets[0].fainted? && targets[0].trainer.battleground.battle_type == 'double'

    if type == Types::FIGHTING && targets[0].types.any? { |type| type == Types::GHOST }
      BattleLog.instance.log(MessagesPool.immunity_msg(targets[0].name))
    else
      perform_dmg(dmg)
    end
    pokemon.reinit_metadata(self)
  end

  def no_pending_action?
    pokemon.trainer.data[:pending_action].nil?
  end
  
  def handle_additional_action(pokemon_target)
    additional_action(pokemon)
    handle_in_other_turn(pokemon_target)
  end

  def execute
    return attack_failed! if targets.all?(&:fainted?)
    
    hits = 0
    targets.each do |pokemon_target|
      return attack_missed! unless hit_chance(pokemon_target)
      effectiveness_message(pokemon_target) if !protected?(pokemon_target)

      strikes_count.times do 
        action(pokemon_target)
        hits += 1
        break if pokemon_target.fainted?
      end

      BattleLog.instance.log(MessagesPool.multi_hit_msg(pokemon_target.name, strikes_count)) if strikes_count > 1
      end_of_execution(pokemon_target)
      pokemon.trainer.battleground.attack_list["#{pokemon.name}"] = self.dup
      pokemon.trainer.battleground.attack_list["last_attack"] = self.dup unless attack_name == :copycat
      BattleLog.instance.log(MessagesPool.leap)
    end
  end

  def hit_chance(pokemon_target)
    return true if precision.nil? || pokemon_target == pokemon
    return true if pokemon_target.metadata[:post_effect] == "vulnerable"
    return false if !pokemon_target.metadata[:invulnerable].nil?

    chance = rand(0..100)
    if @category != :status && ignores_evassion?
      ( precision * pokemon.acc_value ) > chance
    elsif (@category == :status && precision < chance) || (@category != :status && (precision * pokemon.acc_value * pokemon_target.evs_value ) < chance)
      false
    else
      true
    end
  end

  def effectiveness_message(pokemon_target)
    effectiveness = effect(pokemon_target)

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

  def effect(pokemon_target)
    attack_types = [self.type, self.secondary_type].compact
    Types.calc_multiplier( attack_types, pokemon_target.types )
  end

  def strikes_count
    1
  end

  def action(pokemon_target)
    main_effect(pokemon_target)
    if pokemon.was_successful?
      pokemon_target.made_contact(pokemon) if category == :physical
      cast_additional_effect
    end
  end

  def main_effect(pokemon_target)
    if status? 
      return protected_itself(pokemon_target) if pokemon_target != pokemon && protected?(pokemon_target)
      return BattleLog.instance.log(MessagesPool.substitute_immune_msg(pokemon_target.name, attack_name)) if !pokemon_target.volatile_status[:substitute].nil? && pokemon != pokemon_target
      status_effect(pokemon_target)
    else
      damage_effect(pokemon_target)
    end
  end

  def protected?(pokemon_target)
    return true if attack_name == 'Pain Split' && pokemon_target&.is_protected?
    return false if !pokemon_target&.is_protected? || goes_through_protection? || pokemon_target == pokemon
    true
  end

  def protected_itself(pokemon_target)
    BattleLog.instance.log(MessagesPool.was_protected_msg(pokemon_target.name))
    protection_effect(pokemon_target)
  end

  def protection_harm(pokemon_target)
    return unless pokemon_target.metadata[:protected] == :spiky_shield && category == :physical
  
  end

  def protection_effect(pokemon_target)
    return if pokemon_target.metadata[:protected].nil? || category != :physical
    protection_move = pokemon_target.metadata[:protected]

    case protection_move
    when :spiky_shield
      damage = (pokemon.hp_total / 8).to_i
      pokemon.hp.decrease(damage)
      BattleLog.instance.log(MessagesPool.spiky_shield_msg(pokemon.name, damage))
    when :scorching_defense
      health_condition_apply(pokemon, BurnCondition.get_burn) if rand > 0.5
    when :"king's_shield"
      pokemon.public_send(:atk).stage_modifier(pokemon, -1)
    end
  end

  def status_effect(pokemon_target); end

  def damage_effect(pokemon_target)
    damage_calculation(pokemon_target)
  end

  def cast_additional_effect; end

  def end_of_execution(pokemon_target)
    end_turn_action if !pokemon.was_successful?
    pokemon.reinit_metadata(self)
    return if effect(pokemon_target) == 0 && category != :status

    end_of_action_message(pokemon_target)
  end

  def end_of_action_message(pokemon_target)
    BattleLog.instance.log(MessagesPool.pok_fainted_msg(pokemon.name)) if pokemon.fainted?
    BattleLog.instance.log(MessagesPool.pok_fainted_msg(pokemon_target.name)) if pokemon_target.fainted?
    BattleLog.instance.log(MessagesPool.final_hp_msg(pokemon_target.name, pokemon_target.hp_value)) if category != :status && !pokemon_target.fainted?
  end

  def additional_move(pokemon); end

  def health_condition_apply(target, condition)
    return BattleLog.instance.log(MessagesPool.condition_apply_fail_msg(target.name, condition.name)) if condition.name == :frozen && pokemon.trainer.battleground.field.weather&.name == 'Harsh sunlight'
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
      status_apply_msg(target, status.name)
      target.volatile_status[status.name] = status
    else
      attack_failed! if category == :status
    end
  end

  def status_apply_msg(pokemon_target, status)
    case status
    when :confused 
      tar = attack_name == :outrage ? pokemon.name : pokemon_target.name
      BattleLog.instance.log(MessagesPool.confusion_apply(tar))
    when :cursed then BattleLog.instance.log(MessagesPool.curse_apply(pokemon.name, pokemon_target.name)) 
    when :infatuated then BattleLog.instance.log(MessagesPool.infatuation_apply(pokemon_target.name)) 
    when :seeded then BattleLog.instance.log(MessagesPool.seed_apply(pokemon_target.name))
    when :substitute then BattleLog.instance.log(MessagesPool.substitute_apply(pokemon.name))
    when :bound then BattleLog.instance.log(MessagesPool.bound_apply(pokemon.name))
    when :transformed then BattleLog.instance.log(MessagesPool.transform_apply(pokemon.name, targets[0].name))
    when :rooted then BattleLog.instance.log(MessagesPool.root_apply(pokemon.name))
    when :encored then BattleLog.instance.log(MessagesPool.encore_apply(pokemon_target.name))
    when :on_fire then BattleLog.instance.log(MessagesPool.erupted_msg(pokemon.name))
    end
  end

  def return_dmg?
    false
  end

  def ignores_evassion?
    false
  end

  def ignores_stat_changes?
    false
  end

  def status?
    category == :status
  end
  
  def has_post_effect?
    false
  end  
  
  def drain
    false
  end
  
  def crit_ratio
    0
  end

  def end_turn_action
    pokemon.metadata.delete(:turn)
  end
end