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

  def damage_formula(crit)
    variation = rand(85..100)
    level = pokemon.lvl
    attk = crit && atk.stage < 0 ? atk.initial_value : atk.curr_value
    defn = crit && dfn.stage > 0 ? dfn.initial_value : dfn.curr_value
    crit_value = crit || 1
    vulnerability = pokemon_target.metadata[:post_effect] == "vulnerable" ? 2 : 1

    puts "power #{attack.power}, type: #{attack.type}"
    (0.01*bonus*effect*variation*vulnerability*crit_value* ( 2.0+ ((2.0+(2.0*level)/5.0)*attack.power*attk/defn)/50.0 )).to_i
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

  def atk; end
  def dfn; end

  def bonus
    stab = pokemon.types.any? { |type| type == self.type }

    stab ? 1.5 : 1
  end

  def crit_stage
    0
  end

  def recoil
    false
  end
end