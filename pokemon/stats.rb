require 'active_support/inflector'
require_relative "../messenger/messages_pool"
require_relative "../messenger/battle_log"

class Stats
  POSSIBLE_STATS = [:hp, :atk, :def, :sp_atk, :sp_def, :spd, :evs, :acc]
  BUFF_ATK_NATURES = %w[lonely brave adamant naughty]
  NERF_ATK_NATURES = %w[bold timid modest calm]
  BUFF_DEF_NATURES = %w[bold relaxed impish lax]
  NERF_DEF_NATURES = %w[lonely hasty mild gentle]
  BUFF_SP_ATK_NATURES = %w[modest mild quiet rash]
  NERF_SP_ATK_NATURES = %w[adamant impish jolly careful]
  BUFF_SP_DEF_NATURES = %w[calm gentle sassy careful]
  NERF_SP_DEF_NATURES = %w[naughty lax naive rash]
  BUFF_SPD_NATURES = %w[timid hasty jolly naive]
  NERF_SPD_NATURES = %w[brave relaxed quiet sassy]

  attr_accessor :stage, :iv, :ev, :nature
  attr_reader :name, :initial_value, :curr_value

  def initialize(name:, base_value:, ev: 0, iv: 0, nature: 'hardy')
    @name = name
    @base_value = base_value
    @iv = iv
    @ev = ev
    @nature = nature
    @initial_value = 0
    @curr_value = @initial_value
    @stage = stage || 0
  end

  def calc_value(lvl)
    if combat_stat?
      @initial_value = @base_value
      @curr_value = @base_value
    else
      stat_complement = hp? ? (lvl + 5) : 0
      common_formula = ( ( ( ( 2 * @base_value + @iv + ( @ev / 4 )) * lvl ) / 100 ) + 5 )
      calculation = (common_formula + stat_complement) * nature_value
      @initial_value = calculation.to_i
      @curr_value = calculation.to_i
    end
  end

  def nature_value
    return 1 if hp?
    
    if "Stats::BUFF_#{name.upcase}_NATURES".constantize.include?(nature)
      1.1
    elsif "Stats::NERF_#{name.upcase}_NATURES".constantize.include?(nature)
      0.9
    else
      1
    end
  end

  def stage_modifier(target, stages)
    return if hp?
    return BattleLog.instance.log(MessagesPool.stat_at_max_msg(name)) if max_stage? && stages > 0
    return BattleLog.instance.log(MessagesPool.stat_at_min_msg(name)) if min_stage? && stages < 0
    
    @stage = (stage + stages).clamp(-6, 6)
    @curr_value = initial_value * calc_stage
    stat_variation_msg(target, stages)
  end

  def calc_stage
    return if hp?
    
    factor = 2.0 + (combat_stat? ? 1 : 0)
    numerator = 0
    denominator = 0

    if evs?
      numerator = stage < 0 ? -stage : 0
      denominator = stage > 0 ? stage : 0
    else
      numerator = stage > 0 ? stage : 0
      denominator = stage < 0 ? -stage : 0
    end

    (factor + numerator) / (factor + denominator)
  end

  def in_game_stat_calc
    return if hp?
    @curr_value = curr_value * calc_stage
  end

  def decrease(value)
    return unless hp?
    old_hp = curr_value

    if old_hp - value <= 0 
      @curr_value = 0
    else
      @curr_value -= value
    end
  end

  def increase(value)
    return unless hp?

    @curr_value += value
    curr_value > initial_value ? @curr_value = initial_value : @curr_value
  end

  def endured_the_hit
    return unless hp?

    @curr_value = 1
  end
  
  def reset_stat
    return if hp?
    @curr_value = @initial_value
    @stage = 0
  end
 
  def max_stage?
    stage == 6
  end

  def min_stage?
    stage == -6
  end

  def regular_stat?
    [:hp, :atk, :def, :sp_atk, :sp_def, :spd].include?(name)
  end

  def combat_stat?
    [:evs, :acc].include?(name)
  end

  POSSIBLE_STATS.each do |stat|
    define_method("#{stat}?") do
      name == stat
    end
  end

  def stat_variation_msg(target, stages)
    possible_texts = {
      1 => "rose!",
      2 => "sharply rose!",
      3 => "drastically rose!",
      -1 => "fell!",
      -2 => "harshly fell!",
      -3 => "severely fell!"
    }
    
    text = possible_texts[stages]
    BattleLog.instance.log(MessagesPool.stat_variation_msg(target.name, name, text))
  end
end
