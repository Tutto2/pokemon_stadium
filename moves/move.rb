curr_dir = File.dirname(__FILE__)
concerns_path = File.join(curr_dir, '.', 'concerns')
file_paths = Dir.glob(File.join(concerns_path, '*.rb'))

health_conditions_path = File.join(curr_dir, '../conditions', 'health_conditions')
conditions_paths = Dir.glob(File.join(health_conditions_path, '*.rb'))

conditions_paths.each do |condition_paths|
  require_relative condition_paths
end
file_paths.each do |file_path|
  require_relative file_path
end
require_relative "../pokemon/pokemon"
require_relative "../types/type_factory"


class Move
  include Messages
  include DamageFormula
  include SpecialFeatures

  attr_reader :attack_name, :precision, :power, :priority, :pokemon, :pokemon_target
  attr_accessor :category, :type, :secondary_type, :metadata

  def initialize(attack_name: nil, type: nil, secondary_type: nil, category: nil, precision: 100, power: 0, priority: 0, metadata: nil)
    @attack_name = attack_name
    @type = type
    @secondary_type = secondary_type
    @category = category
    @precision = precision
    @power = power
    @priority = priority
    @metadata = metadata
  end

  def perform_attack(*pokemons)
    @pokemon, @pokemon_target = pokemons

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
      puts "#{pokemon.name} used #{attack_name}"
      trigger_perform
    end
  end
  
  def perform_normal_attack
    puts "#{pokemon.name} used #{attack_name} (#{category}, type: #{type})"
    
    if has_several_turns?
      action_per_turn 
    elsif hit_chance
      execute
    end
  end

  def execute
    effectiveness_message(pokemon, pokemon_target, effect, self)
    if effect != 0 || category == :status
      strikes_count ? perform_multistrike : action
      end_of_action_message(pokemon, pokemon_target)

      end_turn_action if pokemon.metadata[:turn] == nil
      post_effect(pokemon) if has_post_effect?
    end
  end

  def additional_move; end

  private
  attr_reader :pokemon, :pokemon_target

  def additional_action(pokemon); end

  def trigger_perform
    return execute if trigger(pokemon) 

    puts "But it failed."
    pokemon.reinit_metadata
  end

  def action_per_turn
    if pokemon.metadata[:turn].nil?
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
    multihit_message(hits, pokemon_target)
  end

  def action
    main_effect
    cast_additional_effect if pokemon.was_successful
    puts
  end
  
  def main_effect
    status? ? status_effect : damage_effect
  end

  def status_effect; end

  def damage_effect
    damage_calculation(self, pokemon, pokemon_target, effect)
  end

  def health_condition_apply(target, condition)
    if target == pokemon || ( target.health_condition.nil? && !(target.types.any? { |type| type == condition.immune_type }) )
      target.health_condition = condition
      puts "#{target.name} got #{condition.name}!"
    end
  end
  
  def cast_additional_effect; end

  def end_turn_action
    pokemon.reinit_metadata
  end

  def has_post_effect?
    false
  end
end