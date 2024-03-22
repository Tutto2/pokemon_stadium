require_relative "../messages_pool"
require_relative "../battle_log"
require_relative "../actions/action"
require_relative "../types/type_factory"
require_relative "stats"
require_relative "metadata_handling"
require_relative "../conditions/health_conditions/health_conditions"
require "pry"

class Pokemon
  include MetadataHandling

  attr_reader :name, :lvl
  attr_accessor :stats, :types, :attacks, :gender, :weight, :condition, :trainer, :field_position, :metadata, :health_condition, :volatile_status
  def initialize(name:, types:, stats:, weight:, attacks:, lvl: 50, gender: nil, trainer: nil, field_position: nil, health_condition: nil, volatile_status: {}, teratype: nil)
    @name = name
    @types = types
    @stats = stats
    @weight = weight
    @attacks = attacks
    @lvl = lvl
    @gender = gender
    @trainer = trainer
    @field_position = field_position
    @metadata = {crit_stage: 0, harm: 0, actions: 0}
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

  def assing_target(attack, target_positions)
    tar = attack.target
    battle_type = trainer.battleground.battle_type

    return [self] if tar == 'self' || attack.return_dmg?
    return [] if tar == 'teammate' && battle_type != 'double'

    field_positions = trainer.battleground.field.positions
    self_position = field_positions.find { |i, pok| pok == self }
    self_position_index = self_position[0]

    if battle_type == 'single'
      self_position_index.odd? ? [field_positions[2]] : [field_positions[1]]
    elsif battle_type == 'double' && target_positions != nil && target_positions.size == 1
      pos = target_positions[0]
      if pos == 3
        special_targeting('teammate', field_positions, self_position_index)
      else
        self_position_index.odd? ? [field_positions[pos * 2]] : [field_positions[(pos * 2) - 1]]
      end
    else
      special_targeting(tar, field_positions, self_position_index)
    end
  end

  def special_targeting(tar, field_positions, self_position_index)
    targets = []

    case tar
    when 'all_opps'
      if self_position_index.odd?
        targets << field_positions[2]
        targets << field_positions[4]
      else
        targets << field_positions[1]
        targets << field_positions[3]
      end
    when 'random_opp'
      x = rand(1..2)
      if self_position_index.odd?
        targets << field_positions[x * 2]
      else
        targets << field_positions[(x * 2) - 1]
      end
    when 'all_except_self'
      field_positions.each do |index, pok|
        next if index == self_position_index
        targets << pok
      end
    when 'teammate'
      teammate_mapping = {
        1 => 3,
        3 => 1,
        2 => 4,
        4 => 2
      }
      
      teammate_index = teammate_mapping[self_position_index]
      pok = field_positions[teammate_index]
      targets << pok
    end

    targets
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
      @weight = att[:weight]
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