require_relative "../messenger/messages_pool"
require_relative "../messenger/battle_log"
require_relative "../types/type_factory"
require_relative "stats"
require_relative "metadata_handling"
require_relative "target_management"
require "pry"

class Pokemon
  include MetadataHandling
  include TargetManagement

  attr_reader :name, :nature, :nickname, :ivs, :evs, :lvl
  attr_accessor :stats, :types, :attacks, :gender, :condition, :trainer, :field_position, :metadata, :health_condition, :volatile_status
  def initialize(name:, nickname: nil, gender: nil, nature: nil, types:, stats:, ivs: nil, evs: nil, attacks:, lvl: 50, trainer: nil, field_position: nil, health_condition: nil, volatile_status: {}, teratype: nil)
    @name = name
    @nickname = nickname || name
    @gender = gender
    @nature = nature || define_nature
    # @weight = weight
    @types = types
    @stats = stats
    @ivs = ivs || set_default_ivs
    @evs = evs || set_default_evs
    @attacks = attacks
    @lvl = lvl
    @trainer = trainer
    @field_position = field_position
    @metadata = {crit_stage: 0, harm: 0, actions: 0}
    @health_condition = health_condition
    @volatile_status = volatile_status
    @teratype = teratype || types.sample

    calc_stats
  end

  def define_nature
    neutral_natures = %w[
      hardy
      docile
      bashful
      quirky
      serious
    ]

    neutral_natures.sample
  end

  def set_default_ivs
    [31]*6
  end

  def set_default_evs
    [0]*6
  end

  def calc_stats
    @stats.each.with_index { |stat, index| stat.iv = ivs[index] }
    @stats.each.with_index { |stat, index| stat.ev = ivs[index] }
    @stats.map { |stat| stat.nature = nature }

    @stats.push(
      Stats.new(name: :evs, base_value: 1),
      Stats.new(name: :acc, base_value: 1)
    )

    @stats.each {|stat| stat.calc_value(lvl) }
  end

  def status
    display_substitute_message
    MessagesPool.pokemon_state(self)
  end

  def display_substitute_message
    substitute_status = volatile_status[:substitute]
    return unless substitute_status
  
    MessagesPool.substitute_state(name, substitute_status.data.to_i)
  end

  def actual_speed
    health_condition == :paralyzed ? ( spd_value / 2 ) : spd_value
  end

  def view_attacks
    attacks.each.with_index(1) do |atk, index|
      BattleLog.instance.log(MessagesPool.atk_index(atk, index))
    end
    BattleLog.instance.display_messages
  end

  def attack!(action)
    attack = action.behaviour
    targets = assing_target(attack, action.target)
    
    evaluate_mute_turn
    return BattleLog.instance.log(MessagesPool.sound_based_blocked_msg(name)) if sound_based_attack_blocked?(attack)

    condition_disappear?
    return if is_unable_to_move?

    attack.perform_attack(self, targets)
  end

  def condition_disappear?
    return if health_condition.nil? && volatile_status.empty?

    health_condition_disappear?
    volatile_condition_disappear?
  end

  def health_condition_disappear?
    return if health_condition.nil?

    if health_condition == :asleep && health_condition.wake_up?
      BattleLog.instance.log(MessagesPool.woke_up_msg)
      @health_condition = nil
    end
  end

  def volatile_condition_disappear?
    return if volatile_status.empty?

    volatile_status.each do |name, status|
      if status.wear_off?
        BattleLog.instance.log(MessagesPool.status_wore_off_msg(name)) unless name == :flinched
        volatile_status.delete(name)
      end
    end
  end
  
  def is_unable_to_move?
    return if health_condition.nil? && volatile_status.empty?

    if health_condition&.unable_to_move
      BattleLog.instance.log(MessagesPool.unable_to_move_msg(name, health_condition.name))
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

  def flinched?
    return false if volatile_status[:flinched].nil?

    BattleLog.instance.log(MessagesPool.flinched_msg(name))
    volatile_status[:flinched].unable_to_attack?
  end

  def confused?
    return false if volatile_status[:confused].nil?

    BattleLog.instance.log(MessagesPool.confused_msg(name))
    volatile_status[:confused].unable_to_attack? ? perform_confusion_dmg : false
  end

  def perform_confusion_dmg
    dmg = confusion_damage
    BattleLog.instance.log(MessagesPool.confusion_dmg_msg(name, dmg))
    self.hp.decrease(dmg)
    self.harm_recieved(dmg, self)
  end

  def confusion_damage
    variation = rand(85..100)
    power = 40
    vulnerability = metadata[:post_effect] == "vulnerable" ? 2 : 1

    (0.01*variation*vulnerability* ( 2.0+ ((2.0+(2.0*lvl)/5.0)*power*atk_value/def_value)/50.0 )).to_i
  end


  def infatuated?
    return false if volatile_status[:infatuated].nil?

    BattleLog.instance.log(MessagesPool.infatuated_msg(name))
    volatile_status[:infatuated].unable_to_attack?
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
    field_position.even? && other.field_position.even? || field_position.odd? && other.field_position.odd?
  end

  def got_out_of_battle
    stats.each do |stat|
      stat.reset_stat
    end
    reinit_all_metadata
    reinit_volatile_condition
    field_position = nil
  end

  def reinit_volatile_condition
    unless volatile_status[:transformed].nil?
      att = volatile_status[:transformed].data
      previous_stats = att[:stats]
      @types = att[:types]
      # @weight = att[:weight]
      @gender = att[:gender]
      @attacks = att[:attacks]
      reinit_stats(previous_stats)
    end

    @volatile_status = {}
  end

  def reinit_stats(previous_stats)
    stats_transfer = []
    previous_stats.each do |stat|
      stats_transfer << stat.dup unless stat.hp?
    end
    @stats.each_with_index do |stat, index|
      @stats[index] = stats_transfer.shift unless stat.hp?
    end
  end
 
  def terastallized
    false
  end

  def to_s
    name == nickname ? name : "#{nickname} (#{name})"
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