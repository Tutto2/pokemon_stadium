require_relative "../actions/action"
require_relative "../types/type_factory"
require_relative "stats"
require_relative "../conditions/health_conditions/health_conditions"
require "pry"

class Pokemon
  attr_reader :name, :types, :attacks, :lvl, :weight
  attr_accessor :stats, :condition, :metadata, :health_condition
  def initialize(name:, types:, stats:, weight:, attacks:, lvl: 50, health_condition: nil, teratype: nil)
    @name = name
    @types = types
    @stats = stats
    @weight = weight
    @attacks = attacks
    @lvl = lvl
    @metadata = {}
    @stats.push(
      Stats.new(name: :evs, base_value: 1),
      Stats.new(name: :acc, base_value: 1)
    )
    @stats.each {|stat| stat.calc_value(lvl) }
    @health_condition = health_condition
    @teratype = teratype || types.sample
  end

  def view_attacks
    attacks.each.with_index(1) do |atk, index|
      puts "#{index}- #{atk.attack_name}"
    end
  end

  def attack!(action)
    attack = action.behaviour
    return attack.perform_attack(self, action.target.current_pokemon) if health_condition.nil?
    return attack.perform_attack(self, action.target.current_pokemon) unless health_condition.unable_to_move
    puts "#{name} is #{health_condition.name}, it was unable to move"
    puts
  end

  def status
    puts "#{@name} - #{hp_value} / #{hp_total} hp (#{types.map(&:to_s).join("/")}) #{health_condition&.name}"
    stats.each do |stat|
      puts "#{stat.name} #{stat.curr_value} / #{stat.initial_value} / #{stat.stage}"
    end
    nil
  end

  def fainted?
    hp_value <= 0
  end

  def init_several_turn_attack
    @metadata[:turn] = 1
  end

  def count_attack_turns
    metadata[:turn] += 1
  end

  def is_attacking?
    !metadata[:turn].nil?
  end

  def init_whole_turn_action
    @metadata[:harm] = 0
  end

  def harm_recieved
    return if metadata[:harm].nil?
    metadata[:harm] += 1
  end

  def got_harm?
    metadata[:harm] == 1
  end

  def has_banned_attack?
    !metadata[:banned].nil?
  end

  def reinit_metadata
    @metadata = {}
  end
 
  def terastallized
    false
  end

  def to_s
    @name
  end

  def ==(other)
    @name == other.name
  end

  ::Stats::POSSIBLE_STATS.each do |stat|
    define_method("hp_total") do
      stats.find(&:hp?).initial_value
    end if stat == :hp

    define_method("#{stat}_value") do
      stats.find(&:"#{stat}?").curr_value
    end

    define_method(stat) do
      stats.find(&:"#{stat}?")
    end
  end
end

# ESTUDIAR METODOS ACCESORES
# AGREGAR ESTADOS DE SALUD DEL POKE (CONFUSION, CONGELADO, QUEMADO, ETC)
