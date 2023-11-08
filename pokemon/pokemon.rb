require_relative "../types/type_factory"
require_relative "stats"
require_relative "conditions"
require "pry"

class Pokemon
  attr_reader :name, :types, :attacks, :lvl, :weight
  attr_accessor :stats, :condition, :metadata
  def initialize(name:, types:, stats:, weight:, attacks:, lvl: 50, metadata: nil)
    @name = name
    @types = types
    @stats = stats
    @weight = weight
    @attacks = attacks
    @lvl = lvl
    @metadata = metadata
    @stats.push(
      Stats.new(name: :evs, base_value: 1),
      Stats.new(name: :acc, base_value: 1)
    )
    @stats.each {|stat| stat.calc_value(lvl) }

    # @condition = condition
  end

  def init_whole_turn_action
    @metadata = {harm: 0}
  end

  def init_several_turn_attack
    @metadata = {turn: 1}
  end

  def count_attack_turns
    metadata[:turn] += 1
  end

  def reinit_metadata
    @metadata = nil
  end

  def got_harm?
    if metadata[:harm] == 1
      true 
    else
      false
    end
  end

  def harm_recieved
    return if metadata.nil?
    metadata[:harm] = 1
  end

  def is_attacking?
    true if !metadata.nil?
  end
  
  def fainted?
    hp_value <= 0
  end

  def view_attacks
    @attacks.each.with_index(1) do |atk, index|
      puts "#{index}- #{atk.attack_name}"
    end
  end

  def attack!(atk_index, target)
    @curr_attk = @attacks[atk_index-1]
    @curr_attk.make_action(self, target)
  end

  def status
    puts "#{@name} - #{hp_value} / #{hp_total} hp (#{types.map(&:to_s).join("/")})"
    stats.each do |stat|
      puts "#{stat.name} #{stat.curr_value} / #{stat.initial_value} / #{stat.stage}"
    end
    nil
  end

  def terastallized
    false
  end

  def atk_priority(attk_num)
    atk = @attacks[attk_num-1]
    AtkPriority.new(atk.priority, spd_value)
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

class AtkPriority
  attr_reader :priority, :speed
  def initialize(priority, speed)
    @priority = priority
    @speed = speed
  end

  def <=>(other)
    if self.priority > other.priority
      -1
    elsif self.priority < other.priority
      1
    else
      other.speed <=> self.speed
    end
  end
end

# ESTUDIAR METODOS ACCESORES
# AGREGAR ESTADOS DE SALUD DEL POKE (CONFUSION, CONGELADO, QUEMADO, ETC)
