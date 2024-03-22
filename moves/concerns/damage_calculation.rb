curr_dir = File.dirname(__FILE__)
file_paths = Dir.glob(File.join(curr_dir, '*.rb'))

require_relative "../move"
require_relative "../../messages_pool"
require_relative "../../battle_log"
require_relative "../../pokemon/stats"
require_relative "../../pokemon/pokemon"
file_paths.each do |file_path|
  require_relative file_path
end

module DamageFormula
  attr_accessor :pokemon_target, :effectiveness

  def damage_calculation(pokemon_target)
    @pokemon_target = pokemon_target
    @effectiveness = effect(pokemon_target)
    
    perform_dmg(damage_formula(crit_chance))
  end 

  def perform_dmg(dmg)
    @pokemon_target = targets[0] if pokemon_target.nil?
      
    target_initial_hp = pokemon_target.hp.curr_value
    case targets.size
    when 2
      dmg = dmg * 0.75
    when 3
      dmg = dmg * 0.5
    end

    return protected_itself(pokemon_target) if protected?(pokemon_target)
    return BattleLog.instance.log(MessagesPool.no_dmg_msg(pokemon_target.name)) if dmg <= 0 && category != :status
    return substitute_take_dmg(dmg) if !pokemon_target&.volatile_status[:substitute].nil? && !sound_based?

    if !pokemon_target.metadata[:will_survive].nil? && pokemon_target.hp.curr_value <= 0
      pokemon_target.hp.endured_the_hit
      BattleLog.instance.log(MessagesPool.endured_msg(pokemon_target.name))
    end
    pokemon_target.hp.decrease(dmg)

    dmg_value = target_initial_hp - pokemon_target.hp.curr_value
    BattleLog.instance.log(MessagesPool.dmg_recieved_msg(pokemon_target.name, dmg_value))
    pokemon_target.harm_recieved(dmg, pokemon)
    pokemon.successful_perform
    drain_calculation(dmg)
    recoil_calculation(dmg)
    defrost_evaluation
  end

  def substitute_take_dmg(dmg)
    substitute_status = pokemon_target.volatile_status[:substitute]

    BattleLog.instance.log(MessagesPool.substitute_dmg_recieved_msg(pokemon_target.name, dmg))
    substitute_status.data -= dmg

    if substitute_status.data <= 0
      BattleLog.instance.log(MessagesPool.substitute_broke_msg(pokemon_target.name))
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
    
    BattleLog.instance.log(MessagesPool.attack_power_msg(power))
    (0.01*bonus*effectiveness*variation*vulnerability*burn*crit_value* ( 2.0+ ((2.0+(2.0*level)/5.0)*power*attk/defn)/50.0 )).to_i
  end

  def crit_chance
    pok_stage = pokemon.metadata[:crit_stage].to_i
    move_stage = crit_ratio
    chance_by_stage = { 0 => 0.0417, 1 => 0.125, 2 => 0.5 }

    chance = chance_by_stage[pok_stage + move_stage] || 1
    return false if rand > chance

    BattleLog.instance.log(MessagesPool.critical_hit_msg)
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

    BattleLog.instance.log(MessagesPool.hp_restored_msg(pokemon.name, drain)) if pokemon.hp_value != initial_hp
  end

  def recoil_calculation(dmg)
    return unless recoil

    recoil_dmg = calc_recoil(dmg, pokemon.hp_total).to_i
    BattleLog.instance.log(MessagesPool.recoil_msg(pokemon.name, recoil_dmg))
    pokemon.hp.decrease(recoil_dmg)
  end

  def defrost_evaluation
    if pokemon_target.health_condition == :frozen
      if attack.type == Types::FIRE || attack.can_defrost?(attack.attack_name)
        BattleLog.instance.log(MessagesPool.thawed_out_msg(pokemon_target.name))
        pokemon_target.health_condition = nil
      end
    end
  end
end