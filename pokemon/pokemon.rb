require_relative "../actions/action"
require_relative "../types/type_factory"
require_relative "stats"
require_relative "metadata_handling"
require_relative "../conditions/health_conditions/health_conditions"
require "pry"

class Pokemon
  include MetadataHandling

  attr_reader :name, :types, :attacks, :lvl, :gender, :weight
  attr_accessor :stats, :condition, :trainer, :metadata, :health_condition, :volatile_status
  def initialize(name:, types:, stats:, weight:, attacks:, lvl: 50, gender: nil, trainer: nil, health_condition: nil, volatile_status: {}, teratype: nil)
    @name = name
    @types = types
    @stats = stats
    @weight = weight
    @attacks = attacks
    @lvl = lvl
    @gender = gender
    @trainer = trainer
    @metadata = {crit_stage: 0, harm: 0}
    @stats.push(
      Stats.new(name: :evs, base_value: 1),
      Stats.new(name: :acc, base_value: 1)
    )
    @stats.each {|stat| stat.calc_value(lvl) }
    @health_condition = health_condition
    @volatile_status = volatile_status
    @teratype = teratype || types.sample
  end

  def status
    if !volatile_status[:substitute].nil?
      puts "#{@name}'s Substitute has #{volatile_status[:substitute].data.to_i} hp"
    end
    
    puts "#{@name} - #{hp_value} / #{hp_total} hp (#{types.map(&:to_s).join("/")}) #{health_condition&.name}"
    volatile_status.each { |k, v| puts "#{k}"}

    stats.each do |stat|
      next if stat == hp || stat == spd
      puts "#{stat.name} #{stat.curr_value} / #{stat.initial_value} / #{stat.stage}"
    end
    puts "spd #{actual_speed} / #{spd.initial_value} / #{spd.stage}"
    nil
  end

  def actual_speed
    health_condition == :paralyzed ? ( spd_value / 2 ) : spd_value
  end

  def view_attacks
    attacks.each.with_index(1) do |atk, index|
      puts "#{index}- #{atk.attack_name} (#{atk.pp.to_i} PP)"
    end
  end

  def attack!(action)
    attack = action.behaviour
    target = action.target.current_pokemon

    evaluate_mute_turn
    return puts "#{name} can't use sound-based moves for a while" if sound_based_attack_blocked?(attack)

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
        puts "#{name} wore off!" unless name == :flinched
        volatile_status.delete(name)
      end
    end
  end
  
  def is_unable_to_move?
    return if health_condition.nil? && volatile_status.empty?

    if health_condition&.unable_to_move
      puts
      puts "#{name} is #{health_condition.name}, it was unable to move"
      true
    elsif volatile_status.any? { |name, _| volatile_status_blocking_action(name) }
      flinched? || confused? || infatuated?
    else
      false
    end
  end

  def volatile_status_blocking_action(condition_name)
    conditions = %i[
      confused
      infatuated
      flinched
    ]
    
    conditions.include?(condition_name)
  end

  def confused?
    return false if volatile_status[:confused].nil?

    puts "#{name} is confused."
    volatile_status[:confused].unable_to_attack? ? perform_confusion_dmg : false
  end

  def perform_confusion_dmg
    dmg = confusion_damage
    puts "#{name} hurt itself in its confusion (#{dmg})"
    self.hp.decrease(dmg)
    self.harm_recieved(dmg)
  end

  def confusion_damage
    variation = rand(85..100)
    power = 40
    vulnerability = metadata[:post_effect] == "vulnerable" ? 2 : 1

    (0.01*variation*vulnerability* ( 2.0+ ((2.0+(2.0*lvl)/5.0)*power*atk_value/def_value)/50.0 )).to_i
  end


  def infatuated?
    return false if volatile_status[:infatuated].nil?

    puts "#{name} is in love."
    volatile_status[:infatuated].unable_to_attack?
  end

  def flinched?
    return false if volatile_status[:flinched].nil?

    puts "#{name} flinch after being attacked"
    volatile_status[:flinched].unable_to_attack?
  end

  def has_no_remaining_pp?
    attacks.all? { |atk| atk.no_remaining_pp? }
  end

  def fainted?
    hp_value <= 0
  end

  def opposite_gender(pokemon_target)
    case gender
    when :male then pokemon_target.gender == :female
    when :female then pokemon_target.gender == :male
    else false
    end
  end

  def allied?(other)
    trainer == other.trainer
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
    object_id == other.object_id
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