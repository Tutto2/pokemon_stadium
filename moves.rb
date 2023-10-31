require_relative "type_factory"
require_relative "stats"
require_relative "pokemon"

class Move
  attr_reader :attack_name, :precision, :power, :priority
  attr_accessor :category, :type, :secondary_type

  def initialize(attack_name:, type:, secondary_type: nil, category:, precision: 100, power: 0, priority: 0)
    @attack_name = attack_name
    @type = type
    @secondary_type = secondary_type
    @category = category
    @precision = precision
    @power = power
    @priority = priority
  end

  def perform(*pokemons)
    @pokemon, @pokemon_target = pokemons
    puts
    puts "#{pokemon.name} used #{attack_name}"
    if hit_chance
      effectiveness_message
      if effect != 0 || category == :status
        if strikes_count 
          strikes_count.times do 
            action 
          end
          multihit_message(strikes_count)
        else
          action
        end
        end_of_action_message
      end
    end
  end

  private
  attr_reader :pokemon, :pokemon_target

  def hit_chance
    return true if precision.nil?

    chance = rand(0..100)
    if @category == :status && precision < chance
      failed_attack_message
    elsif @category != :status && (precision * pokemon.acc_value * pokemon_target.evs_value ) < chance
      failed_attack_message
    else
      return true
    end
    puts
  end

  def action
    main_effect
    cast_additional_effect
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

  def status?
    category == :status
  end

  def damage_formula(crit)
    variation = rand(85..100)
    level = pokemon.lvl
    attk = crit && atk.stage < 0 ? atk.initial_value : atk.curr_value
    defn = crit && dfn.stage > 0 ? dfn.initial_value : dfn.curr_value
    crit_value = crit || 1

    (0.01*bonus*effect*variation*crit_value* ( 2.0+ ((2.0+(2.0*level)/5.0)*power*attk/defn)/50.0 )).to_i
  end

  def perform_dmg(dmg)
    if dmg > 0
      puts "#{pokemon_target.name} has recieved #{dmg} damage"
      pokemon_target.hp.decrease(dmg)
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
    PokemonType.calc_multiplier( attack_types, pokemon_target.types )
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
    if pokemon_target.fainted?
      puts "#{pokemon_target.name} has fainted"
    elsif category != :status
      puts "#{pokemon_target.name} now has #{pokemon_target.hp_value} hp"
    end
  end
end

module BasicPhysicalAtk
  private

  def atk
    pokemon.atk
  end

  def dfn
    pokemon_target.def
  end
end

module BasicSpecialAtk
  private

  def atk
    pokemon.sp_atk
  end

  def dfn
    pokemon_target.sp_def
  end
end

module HasSecondaryEffect
  private

  def cast_additional_effect
    secondary_effect if rand < trigger_chance
  end

  def secondary_effect; end

  def trigger_chance
    1
  end
end

module HasHighCritRatio
  private

  def crit_stage
    1
  end
end

module HasRecoil
  def calc_recoil(dmg, hp)
    recoil_base(dmg, hp).to_f * recoil_factor
  end

  private
  def recoil_factor; end

  def recoil_base(dmg, hp)
    dmg
  end

  def recoil
    true
  end
end

module HasCustomTable
  def power
    table.each do |(range, power)|
      power if range.include?(calculation_stat)
    end
  end
  
  private
  def calculation_stat; end

  def table
    table = []
  end
end

module HpChange
  def lose_hp(target = pokemon)
    target.hp.decrease(value).to_i
    puts "#{target} has lost #{value} hp"
  end

  def gain_hp(target = pokemon)
    initial_hp = target.hp_value

    target.hp.increase(value).to_i
    puts "#{target.name} has recover #{(target.hp_value) - (initial_hp)} hp"
  end

  private
  def value; end
end

module StatChanges
  def stat_changes(target = pokemon)
    stat.each do |(stat, stages)|
      target.public_send(stat).stage_modifier(target, stages)
    end
  end

  private
  def stat; end
end

module MultiStrikeAtk
  def strikes_count
    return hits unless hits == :random

    case rand(0..100)
    when 0..34 then 2
    when 35..69 then 3
    when 70..84 then 4
    else 5
    end
  end

  private
  def hits
    :random
  end
end

class ScalePulseMove < Move
  include BasicSpecialAtk

  def self.learn
    new(  attack_name: :scale_pulse,
          type: PokemonType::BUG, 
          secondary_type: PokemonType::DRAGON,
          category: :special,
          power: 85
        )
  end

  private
  def dfn
    pokemon_target.def
  end
end

class SeedBombMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(  attack_name: :seed_bomb,
          type: PokemonType::GRASS,
          category: :physical,
          power: 80
        )
  end
end

class FlamethrowerMove < Move
  include BasicSpecialAtk
  # Can burn 10%

  def self.learn
    new(  attack_name: :flamethrower,
          type: PokemonType::FIRE,
          category: :special,
          power: 90
        )
  end
end

class BitterMaliceMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges
  # Cause frostbite

  def self.learn
    new(  attack_name: :bitter_malice,
          type: PokemonType::GHOST,
          category: :special,
          power: 80,
        )
  end

  private
  def secondary_effect
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:atk, -1]
    ]
  end
end

class PowerGemMove < Move
  include BasicSpecialAtk

  def self.learn
    new(  attack_name: :power_gem,
          type: PokemonType::ROCK,
          category: :special,
          power: 80
        )
  end
end

class MakeItRainMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :make_it_rain,
          type: PokemonType::STEEL,
          category: :special,
          power: 120
        )
  end

  private
  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:sp_atk, -1]
    ]
  end
end

class SolarBladeMove < Move
  include BasicPhysicalAtk
  # Charge one turn
  # Agregar tipo fuego?

  def self.learn
    new(  attack_name: :solar_blade,
          type: PokemonType::GRASS,
          category: :physical,
          power: 125
        )
  end
end

class ShadowClawMove < Move
  include BasicPhysicalAtk
  include HasHighCritRatio

  def self.learn
    new(  attack_name: :shadow_claw,
          type: PokemonType::GHOST,
          category: :physical,
          power: 70
        )
  end
end


class FlareBlitzMove < Move
  include BasicPhysicalAtk
  include HasRecoil
  # Can burn 10%
  # Breaks through frozen

  def self.learn
    new(  attack_name: :flare_blitz,
          type: PokemonType::FIRE,
          category: :physical,
          power: 120
        )
  end

  private

  def recoil_factor
    1.0/3.0
  end
end

class PlayRoughMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :play_rough,
          type: PokemonType::FAIRY,
          category: :physical,
          precision: 90,
          power: 90
        )
  end

  private
  def secondary_effect
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:atk, -1]
    ]
  end

  def trigger_chance
    0.1
  end
end

class GigatonHammerMove < Move
  include BasicPhysicalAtk
  # Cannot hit in succession

  def self.learn
    new(  attack_name: :gigaton_hammer,
          type: PokemonType::STEEL,
          category: :physical,
          power: 160
        )
  end
end

class IvyCudgelMove < Move
  include BasicPhysicalAtk
  include HasHighCritRatio
  # Change type

  def self.learn
    new(  attack_name: :evy_cudgel,
          type: PokemonType::FIRE,
          category: :physical,
          power: 100
        )
  end
end

class TeraBlastMove < Move
  include BasicSpecialAtk
  # Change to physical move
  # Change type

  def self.learn
    new(  attack_name: :tera_blast,
          type: PokemonType::DARK,
          category: :special,
          power: 80
        )
  end

  private
  def atk
    pokemon.atk_value > pokemon.sp_atk_value ? pokemon.atk : pokemon.sp_atk
  end
end


class FoulPlayMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(  attack_name: :foul_play,
          type: PokemonType::DARK,
          category: :physical,
          power: 95
        )
  end

  private
  def atk
    pokemon_target.atk
  end
end


class BodyPressMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(  attack_name: :body_press,
          type: PokemonType::NORMAL,
          category: :physical,
          power: 80
        )
  end

  private
  def atk
    pokemon.def
  end
end

class IceShardMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(  attack_name: :ice_shard,
          type: PokemonType::ICE,
          category: :physical,
          priority: 1,
          power: 40
        )
  end
end

class GlaiveRushMove < Move
  include BasicPhysicalAtk
  # Makes vulnerable the user for 1 turn (200% dmg && always hit)

  def self.learn
    new(  attack_name: :glaive_rush,
          type: PokemonType::DRAGON,
          category: :physical,
          power: 120
        )
  end
end

class IcicleSpearMove < Move
  include BasicPhysicalAtk
  include MultiStrikeAtk

  def self.learn
    new(  attack_name: :icecicle_spear,
          type: PokemonType::ICE,
          category: :physical,
          power: 25
        )
  end
end

class CurseMove < Move
  include StatChanges
  # Different effect depending on the poke type

  def self.learn
    new(  attack_name: :curse,
          type: PokemonType::GHOST,
          category: :status
        )
  end

  private
  def status_effect
    stat_changes
  end

  def stat
    [
      [:atk, 1],
      [:def, 1],
      [:spd, -1]
    ]
  end
end

class ShellSmashMove < Move
  include StatChanges

  def self.learn
    new(  attack_name: :shell_smash,
          type: PokemonType::NORMAL,
          category: :status
        )
  end

  private
  def status_effect
    stat_changes
  end

  def stat
    [
      [:atk, 2],
      [:sp_atk, 2],
      [:spd, 2],
      [:def, -1],
      [:sp_def, -1]
    ]
  end
end

class DragonDanceMove < Move
  include StatChanges

  def self.learn
    new(  attack_name: :dragon_dance,
          type: PokemonType::DRAGON,
          category: :status
        )
  end

  private
  def status_effect
    stat_changes
  end

  def stat
    [
      [:atk, 1],
      [:spd, 1]
    ]
  end
end

class FlashMove < Move
  include StatChanges

  def self.learn
    new(  attack_name: :flash,
          type: PokemonType::NORMAL,
          category: :status
        )
  end

  private
  def status_effect
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:acc, -1]
    ]
  end
end

class PsychicMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :psychic,
          type: PokemonType::PSYCHIC,
          category: :special,
          power: 90
        )
  end

  private
  def secondary_effect
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:sp_def, -1]
    ]
  end

  def trigger_chance
    0.1
  end
end

class CalmMindMove < Move
  include StatChanges

  def self.learn
    new(  attack_name: :calm_mind,
          type: PokemonType::PSYCHIC,
          category: :status
        )
  end

  private
  def status_effect
    stat_changes
  end

  def stat
    [
      [:sp_atk, 1],
      [:sp_def, 1]
    ]
  end
end

class ClangingScalesMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :clanging_scales,
          type: PokemonType::DRAGON,
          category: :special,
          power: 110
        )
  end

  private
  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:def, -1]
    ]
  end
end

class ClangorusSoulMove < Move
  include StatChanges
  include HasSecondaryEffect
  include HpChange
  # Fails if curr_hp < 1/3 total

  def self.learn
    new(  attack_name: :clangorus_soul,
          type: PokemonType::DRAGON,
          category: :status
        )
  end

  private
  def status_effect
    stat_changes
  end

  def stat
    [
      [:atk, 1],
      [:def, 1],
      [:sp_atk, 1],
      [:sp_def, 1],
      [:spd, 1]
    ]
  end

  def secondary_effect
    lose_hp
  end

  def value
    (pokemon.hp_total) * ( 1.0 / 3.0 )
  end
end

class BulletSeedMove < Move
  include BasicPhysicalAtk
  include MultiStrikeAtk

  def self.learn
    new(  attack_name: :bullet_seed,
          type: PokemonType::GRASS,
          category: :physical,
          power: 25
        )
  end
end

class CloseCombatMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :close_combat,
          type: PokemonType::FIGHTING,
          category: :physical,
          power: 120
        )
  end

  private
  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:sp_def, -1],
      [:def, -1]
    ]
  end
end

class DragonDartsMove < Move
  include BasicPhysicalAtk
  include MultiStrikeAtk
  # Special thing on doubles

  def self.learn
    new(  attack_name: :dragon_darts,
          type: PokemonType::DRAGON,
          category: :physical,
          power: 50
        )
  end

  private
  def hits
    2
  end
end


class DracoMeteorMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :draco_meteor,
          type: PokemonType::DRAGON,
          category: :special,
          precision: 90,
          power: 130
        )
  end

  private
  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:sp_atk, -2]
    ]
  end
  
end

class ShadowBallMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :shadow_ball,
          type: PokemonType::GHOST,
          category: :special,
          power: 80
        )
  end

  private
  def secondary_effect
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:sp_def, -1]
    ]
  end

  def trigger_chance
    0.2
  end
end

class DoubleTeamMove < Move
  include StatChanges

  def self.learn
    new(  attack_name: :double_team,
          type: PokemonType::NORMAL,
          category: :status
        )
  end

  private
  def status_effect
    stat_changes
  end

  def stat
    [
      [:evs, 1]
    ]
  end
end

class ExtremeSpeedMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(  attack_name: :extreme_speed,
          type: PokemonType::NORMAL,
          category: :physical,
          power: 80,
          priority: 2
        )
  end
end

class SwordDanceMove < Move
  include StatChanges

  def self.learn
    new(  attack_name: :sowrd_dance,
          type: PokemonType::NORMAL,
          category: :status
        )
  end

  private
  def status_effect
    stat_changes
  end

  def stat
    [
      [:atk, 2]
    ]
  end
end

class AgilityMove < Move
  include StatChanges

  def self.learn
    new(  attack_name: :agility,
          type: PokemonType::NORMAL,
          category: :status,
        )
  end

  private
  def status_effect
    stat_changes
  end

  def stat
    [
      [:spd, 2]
    ]
  end
end

class EarthquakeMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(  attack_name: :earthquake,
          type: PokemonType::GROUND,
          category: :physical,
          power: 100
        )
  end
end

class SacredFireMove < Move
  include BasicSpecialAtk
  # 50% burn target

  def self.learn
    new(  attack_name: :sacred_fire,
          type: PokemonType::FIRE,
          category: :special,
          precision: 95,
          power: 100
        )
  end
end

class DoubleEdgeMove < Move
  include BasicPhysicalAtk
  include HasRecoil

  def self.learn
    new(  attack_name: :double_edge,
          type: PokemonType::NORMAL,
          category: :physical,
          power: 120
        )
  end

  private

  def recoil_factor
    1.0/3.0
  end
end

class LeafStormMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :leaf_storm,
          type: PokemonType::GRASS,
          category: :special,
          precision: 90,
          power: 130
        )
  end

  private
  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:sp_atk, -2]
    ]
  end
end

class HydroPumpMove < Move
  include BasicSpecialAtk

  def self.learn
    new(  attack_name: :hydro_pump,
          type: PokemonType::WATER,
          category: :special,
          precision: 80,
          power: 120
        )
  end
end

class SparkMove < Move
  include BasicSpecialAtk
  # 30% parali

  def self.learn
    new(  attack_name: :spark,
          type: PokemonType::ELECTRIC,
          category: :special,
          power: 65
        )
  end
end

class DischargeMove < Move
  include BasicSpecialAtk
  # 30% parali

  def self.learn
    new(  attack_name: :discharge,
          type: PokemonType::ELECTRIC,
          category: :special,
          power: 80
        )
  end
end

class RecoverMove < Move
  include HpChange

  def self.learn
    new(  attack_name: :recover,
          type: PokemonType::NORMAL,
          category: :status,
          precision: nil
        )
  end

  private
  def status_effect
    gain_hp
  end

  def value
    0.5 * pokemon.hp_total
  end
end

class PollenPuffMove < Move
  include BasicSpecialAtk

  def self.learn
    new(  attack_name: :pollen_puff,
          type: PokemonType::BUG,
          category: :special,
          power: 90
        )
  end

  private
  def damage_effect
    if false && pokemon.ally?(pokemon_target)
      # heal_effect(0.5)
    else
      super
    end
  end
end

class GyroBallMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(  attack_name: :gyro_ball,
          type: PokemonType::STEEL,
          category: :physical,
        )
  end

  private

  def power
    [150, ( ( 25 * pokemon_target.spd_value ) / pokemon.spd_value ) + 1 ].min.to_i
  end
end

class ElectroBallMove < Move
  include BasicSpecialAtk
  include HasCustomTable

  def self.learn
    new(  attack_name: :electro_ball,
          type: PokemonType::ELECTRIC,
          category: :special,
        )
  end

  private
  def table
    [
      [0...1, 40],
      [1...2, 60],
      [2...3, 80],
      [3...4, 120],
      [4.., 150]
    ]
  end
  
  def calculation_stat
    (pokemon.spd_value / pokemon_target.spd_value).to_f
  end
end

class GrassKnotMove < Move
  include BasicSpecialAtk
  include HasCustomTable

  def self.learn
    new(  attack_name: :grass_knot,
          type: PokemonType::GRASS,
          category: :special,
        )
  end

  private
  def table
    [
      [0...10, 20],
      [10...25, 40],
      [25...50, 60],
      [50...100, 80],
      [100...200, 100],
      [200.., 120]
    ]
  end
  
  def calculation_stat
    pokemon_target.wt.to_f
  end
end