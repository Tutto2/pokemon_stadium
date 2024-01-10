curr_dir = File.dirname(__FILE__)
file_paths = Dir.glob(File.join(curr_dir, '*.rb'))

require_relative "../move"
require_relative "../../pokemon/stats"
require_relative "../../pokemon/pokemon"
file_paths.each do |file_path|
  require_relative file_path
end

module DamageFormula
  attr_reader :attack, :pokemon, :pokemon_target, :effect

  def damage_calculation(attack, pokemon, pokemon_target, effect)
    @attack, @pokemon, @pokemon_target, @effect = attack, pokemon, pokemon_target, effect
    perform_dmg(damage_formula(crit_chance))
  end 

  def perform_dmg(dmg)
    pokemon.successful_perform
    target_initial_hp = pokemon_target.hp.curr_value

    return protected_itself if protected?
    return puts "#{pokemon_target.name} has not recieved any damage" if dmg <= 0 && category != :status
    return substitute_take_dmg(dmg) if !pokemon_target.volatile_status[:substitute].nil? && !sound_based?

    pokemon_target.hp.decrease(dmg)
    if !pokemon_target.metadata[:will_survive].nil? && pokemon_target.hp.curr_value <= 0
      pokemon_target.hp.endured_the_hit
      puts "#{pokemon_target.name} endured the hit!"
    end

    puts "#{pokemon_target.name} has recieved #{target_initial_hp - pokemon_target.hp.curr_value} damage"
    pokemon_target.harm_recieved(dmg)
    drain_calculation(dmg)
    recoil_calculation(dmg)
    defrost_evaluation
  end

  def substitute_take_dmg(dmg)
    substitute_status = pokemon_target.volatile_status[:substitute]

    puts "#{pokemon_target.name}'s substitute has recieved #{dmg} damage"
    substitute_status.data -= dmg

    if substitute_status.data <= 0
      puts "#{pokemon_target.name}'s substitute broke!"
      pokemon_target.volatile_status.delete(:substitute)
    end
  end

  def damage_formula(crit)
    variation = rand(85..100)
    level = pokemon.lvl
    attk = crit && atk.stage < 0 ? atk.initial_value : atk.curr_value
    defn = crit && dfn.stage > 0 ? dfn.initial_value : dfn.curr_value
    crit_value = crit || 1
    vulnerability = calc_vulnerability
    burn = burn_condition

    puts "Power: #{attack.power}"
    (0.01*bonus*effect*variation*vulnerability*burn*crit_value* ( 2.0+ ((2.0+(2.0*level)/5.0)*attack.power*attk/defn)/50.0 )).to_i
  end

  def crit_chance
    pok_stage = pokemon.metadata[:crit_stage].to_i
    move_stage = crit_ratio
    chance_by_stage = { 0 => 0.0417, 1 => 0.125, 2 => 0.5 }

    chance = chance_by_stage[pok_stage + move_stage] || 1
    puts "Chance of crit: #{chance}"
    return false if rand > chance

    puts "It's a critical hit!" 
    1.5
  end

  def calc_vulnerability
    pokemon_target.metadata[:post_effect] == "vulnerable" ? 2 : 1
  end

  def burn_condition
    pokemon.health_condition == :burned && category == :physical && attack_name != :facade ? 1/2 : 1
  end

  def atk; end
  def dfn; end

  def bonus
    stab = pokemon.types.any? { |type| type == self.type }

    stab ? 1.5 : 1
  end

  def crit_ratio
    0
  end

  def recoil
    false
  end

  def drain_calculation(dmg)
    return unless drain

    drain = calc_drain(dmg)
    initial_hp = pokemon.hp_value
    pokemon.hp.increase(drain)

    puts "#{pokemon.name} restored #{drain} HP" if pokemon.hp_value != initial_hp
  end

  def recoil_calculation(dmg)
    return unless recoil

    recoil_dmg = calc_recoil(dmg, pokemon.hp_total).to_i
    puts "#{pokemon.name} has recieved #{recoil_dmg} of recoil damage"
    pokemon.hp.decrease(recoil_dmg)
  end

  def defrost_evaluation
    if pokemon_target.health_condition == :frozen
      if attack.type == Types::FIRE || attack.can_defrost?(attack.attack_name)
        puts "#{pokemon_target.name} got thawed out"
        pokemon_target.health_condition = nil
      end
    end
  end
end