require_relative "../actions/action"
require_relative "../types/type_factory"
require_relative "stats"
require_relative "../conditions/health_conditions/health_conditions"
require "pry"

class Pokemon
  attr_reader :name, :types, :attacks, :lvl, :weight
  attr_accessor :stats, :condition, :metadata, :health_condition, :volatile_status
  def initialize(name:, types:, stats:, weight:, attacks:, lvl: 50, health_condition: nil, volatile_status: {}, teratype: nil)
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
    @volatile_status = volatile_status
    @teratype = teratype || types.sample
  end

  def view_attacks
    attacks.each.with_index(1) do |atk, index|
      puts "#{index}- #{atk.attack_name}"
    end
  end

  def attack!(action)
    attack = action.behaviour
    target = action.target.current_pokemon

    condition_disappear?
    return if is_unable_to_move?

    attack.perform_attack(self, target)
    puts
  end

  def condition_disappear?
    return if health_condition.nil? && volatile_status.empty?

    health_condition_disappear?
    volatile_condition_disappear?
  end

  def health_condition_disappear?
    return if health_condition.nil?

    if health_condition == :asleep && health_condition.wake_up?
      puts "#{name} woke up!" 
      @health_condition = nil
    end
  end

  def volatile_condition_disappear?
    return if volatile_status.empty?

    volatile_status.each do |name, status|
      if status.wear_off?
        puts "#{name} wore off!" 
        volatile_status.delete[name]
      end
    end
  end
  
  def is_unable_to_move?
    return if health_condition.nil? && volatile_status.empty?

    if health_condition&.unable_to_move
      puts "#{name} is #{health_condition.name}, it was unable to move"
      true
    elsif !volatile_status[:confused].nil?
      puts "#{name} is confused."
      if volatile_status[:confused].unable_to_attack?
        perform_confusion_dmg
        true
      else
        false
      end
    else
      false
    end
  end

  def status
    puts "#{@name} - #{hp_value} / #{hp_total} hp (#{types.map(&:to_s).join("/")}) #{health_condition&.name}"
    volatile_status.each { |k, v| puts "#{k}"}

    stats.each do |stat|
      next if stat == hp || stat == spd
      puts "#{stat.name} #{stat.curr_value} / #{stat.initial_value} / #{stat.stage}"
    end
    puts "spd #{actual_speed} / #{spd.initial_value} / #{spd.stage}"
    nil
  end

  def perform_confusion_dmg
    dmg = confusion_damage
    puts "#{name} hurt itself in its confusion (#{dmg})"
    self.hp.decrease(dmg)
    self.harm_recieved
  end

  def confusion_damage
    variation = rand(85..100)
    power = 40
    vulnerability = metadata[:post_effect] == "vulnerable" ? 2 : 1

    (0.01*variation*vulnerability* ( 2.0+ ((2.0+(2.0*lvl)/5.0)*power*atk_value/def_value)/50.0 )).to_i
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

  def was_successful?
    metadata[:perform] == "success"
  end

  def successful_perform
    metadata[:perform] = "success"
  end

  def actual_speed
    speed = spd_value
    if health_condition == :paralyzed
      speed / 2
    else
      speed
    end
  end

  def reinit_metadata
    @metadata = {}
  end

  def reinit_volatile_condition
    @volatile_status = {}
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
