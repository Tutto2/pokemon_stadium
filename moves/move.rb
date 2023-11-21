curr_dir = File.dirname(__FILE__)
concerns_path = File.join(curr_dir, '.', 'concerns')
file_paths = Dir.glob(File.join(concerns_path, '*.rb'))

require_relative "../types/type_factory"
require_relative "../pokemon/stats"
require_relative "../pokemon/pokemon"

file_paths.each do |file_path|
  require_relative file_path
end

class Move
  attr_reader :attack_name, :precision, :power, :priority
  attr_accessor :category, :type, :secondary_type, :metadata

  def initialize(attack_name:, type:, secondary_type: nil, category:, precision: 100, power: 0, priority: 0, metadata: nil)
    @attack_name = attack_name
    @type = type
    @secondary_type = secondary_type
    @category = category
    @precision = precision
    @power = power
    @priority = priority
    @metadata = metadata
  end

  def has_additional_action?
    false
  end

  def make_action(*pokemons)
    @pokemon, @pokemon_target = pokemons
    puts "#{pokemon.name} used #{attack_name}"
    if has_trigger?
      trigger_perfom(pokemon)
    else
      has_several_turns? ? action_per_turn : perform
    end
  end

  def perform
    if hit_chance
      effectiveness_message
      if effect != 0 || category == :status
        if strikes_count
          perform_multistrike
        else
          action
        end
        end_of_action_message
        if !pokemon.metadata.nil?
          end_turn_action if pokemon.metadata[:turn] == nil
        end
        post_effect(pokemon) if has_post_effect?
      end
    end
  end

  def has_post_effect?
    false
  end

  private
  attr_reader :pokemon, :pokemon_target

  def has_several_turns?
    false
  end

  def action_per_turn
    if pokemon.metadata.nil? || pokemon.metadata[:turn].nil?
      pokemon.init_several_turn_attack 
    end

    case pokemon.metadata[:turn]
    when 1
      first_turn_action
    when 2
      second_turn_action
    when 3
      third_turn_action
    when 4
      fourth_turn_action
    when 5
      fifth_turn_action
    end

    pokemon.count_attack_turns if !pokemon.metadata.nil?
  end

  def end_turn_action
    pokemon.reinit_metadata
  end

  def has_trigger?
    false
  end

  def trigger_perfom(pokemon)
    if trigger(pokemon) 
      perform
    else
      puts "But it failed."
    end
    pokemon.reinit_metadata
  end

  def hit_chance
    return true if precision.nil?
    if !pokemon_target.metadata.nil?
      return true if pokemon_target.metadata[:post_effect] == "vulnerable"
    end

    chance = rand(0..100)
    if @category == :status && precision < chance
      failed_attack_message
      pokemon.reinit_metadata if !pokemon.metadata.nil?
    elsif @category != :status && (precision * pokemon.acc_value * pokemon_target.evs_value ) < chance
      failed_attack_message
      pokemon.reinit_metadata if !pokemon.metadata.nil?
    else
      return true
    end
    puts
  end

  def action
    main_effect
    cast_additional_effect
    puts
  end

  def cast_additional_effect; end
  
  def main_effect
    status? ? status_effect : damage_effect
  end
  
  def status_effect; end

  def damage_effect
    perform_dmg(damage_formula(crit_chance))
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

  def status?
    category == :status
  end

  def damage_formula(crit)
    variation = rand(85..100)
    level = pokemon.lvl
    attk = crit && atk.stage < 0 ? atk.initial_value : atk.curr_value
    defn = crit && dfn.stage > 0 ? dfn.initial_value : dfn.curr_value
    crit_value = crit || 1
    vulnerability = 1
    if !pokemon_target.metadata.nil? 
      vulnerability = 2 if pokemon_target.metadata[:post_effect] == "vulnerable"
    end

    puts "power #{power}, type: #{type}"
    (0.01*bonus*effect*variation*vulnerability*crit_value* ( 2.0+ ((2.0+(2.0*level)/5.0)*power*attk/defn)/50.0 )).to_i
  end

  def perform_dmg(dmg)
    if dmg > 0
      puts "#{pokemon_target.name} has recieved #{dmg} damage"
      pokemon_target.hp.decrease(dmg)
      pokemon_target.harm_recieved
      if recoil
        recoil_dmg = calc_recoil(dmg, pokemon.hp_total).to_i
        puts "#{pokemon.name} has recieved #{recoil_dmg} of recoil damage"
        pokemon.hp.decrease(recoil_dmg)
      end
    end
  end

  def atk; end
  def dfn; end

  def bonus
    stab = pokemon.types.any? { |type| type == self.type }

    stab ? 1.5 : 1
  end

  def effect
    attack_types = [self.type, self.secondary_type].compact
    Types.calc_multiplier( attack_types, pokemon_target.types )
  end

  def crit_chance
    num = rand
    chances = { 0 => 0.0417, 1 => 0.125, 2 => 0.5 }
    chance = chances[crit_stage] || 1

    if num < chance
      puts "It's a critical hit!" 
      return 1.5
    else
      return false
    end
  end

  def crit_stage
    0
  end

  def recoil
    false
  end

  def effectiveness_message
    effectiveness = effect

    unless @category == :status
      if effectiveness < 1 && effectiveness > 0
        puts "It's ineffective"
      elsif effectiveness == 0
        puts "#{pokemon_target.name} it's inmune"
      elsif effectiveness > 1
        puts "It's super effective"
      else
        puts "It's effective"
      end
      puts
    end
  end

  def multihit_message(strikes_count)
    puts "#{pokemon_target.name} received #{strikes_count} hits"
  end

  def failed_attack_message
    puts "The attack has failed"
    return false
  end

  def end_of_action_message
    if pokemon.fainted?
      puts "#{pokemon.name} has fainted"
    end

    if pokemon_target.fainted?
      puts "#{pokemon_target.name} has fainted"
    elsif category != :status
      puts "#{pokemon_target.name} now has #{pokemon_target.hp_value} hp"
    end
  end
end