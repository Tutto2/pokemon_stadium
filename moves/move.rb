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
require_relative "../pokemon/pokemon"
require_relative "../types/type_factory"
require_relative "../actions/menu"
require_relative "../trainer"

class Move
  include Messages
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
    if category == :status && target.nil?
      @target = pokemon 
    elsif category != :status || target == :pokemon_target
      @target = pokemon_target
    end

    if has_trigger?
      perform_attack_with_trigger
    else
      perform_normal_attack
    end
  end
  
  def perform_attack_with_trigger
    if pokemon.metadata[:harm].nil?
      additional_action(pokemon)
      @pokemon.init_whole_turn_action
      puts
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
    return puts "#{pokemon_target.name} protected itself." if pokemon_target.is_protected? && pokemon_target == target
    return puts "#{pokemon.name} failed." if !pokemon_target.metadata[:invulnerable].nil? && pokemon_target == target

    effectiveness_message
    if effect != 0 || category == :status
      strikes_count ? perform_multistrike : action
      end_of_action_message

      pokemon.reinit_metadata
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
    puts "#{pokemon.name} used #{attack_name} (#{category}, type: #{type})"
  end
  
  def trigger_perform
    if trigger(pokemon)
      @pp -= 1
      execute
    else
      puts "But it failed."
      pokemon.reinit_metadata
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
      failed_attack_message
      pokemon.reinit_metadata if !pokemon.metadata.nil?
    else
      return true
    end
    puts
  end

  def effect
    attack_types = [self.type, self.secondary_type].compact
    Types.calc_multiplier( attack_types, pokemon_target.types )
  end

  def strikes_count
    false
  end

  def perform_multistrike
    hits = 0
    strikes_count.times do 
      action
      hits += 1
      break if pokemon_target.fainted?
    end
    multihit_message(hits)
  end

  def action
    main_effect
    if pokemon.was_successful?
      cast_additional_effect
    end
    puts
  end
  
  def main_effect
    if status? 
      return puts "#{attack_name} does not affect #{pokemon_target.name}'s Substitute" if !pokemon_target.volatile_status[:substitute].nil? && !(pokemon == target)
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
        return "#{target.name} cannot get #{condition.name}" if target_type == immune_type
      end
    end
    if target == pokemon || target.health_condition.nil?
      target.health_condition = condition
      puts "#{target.name} got #{condition.name}!"
    else
      puts "But it failed!" if category == :status
    end
  end

  def volatile_status_apply(aim_to, status)
    if aim_to.volatile_status[status.name].nil?
      volatile_status_apply_msg(status.name)
      aim_to.volatile_status[status.name] = status
    else
      puts "But it failed." if category == :status
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
  
  def drain
    false
  end
end