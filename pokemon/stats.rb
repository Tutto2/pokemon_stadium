class Stats
  POSSIBLE_STATS = [:hp, :atk, :def, :sp_atk, :sp_def, :spd, :evs, :acc]

  attr_reader :name, :initial_value, :curr_value, :stage

  def initialize(name:, base_value: , ev: 0, iv: 31, nature_value: 1.0)
    @name = name
    @base_value = base_value
    @ev = ev
    @iv = iv
    @nature_value = name == :hp ? 1.0 : nature_value
    @initial_value = 0
    @curr_value = @initial_value
    @stage = 0
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

  def decrease(value)
    return unless hp?

    @curr_value -= value
  end

  def increase(value)
    return unless hp?

    @curr_value += value
    curr_value > initial_value ? @curr_value = initial_value : @curr_value
  end

  def stage_modifier(target, stages)
    return if hp?
    return puts "#{name} won't go any higher!" if max_stage? && stages > 0
    return puts "#{name} won't go any lower!" if min_stage? && stages < 0
    
    @stage = (stage + stages).clamp(-6, 6)

    @curr_value = initial_value * calc_stage
    stat_variation_message(target, stages)
  end

  def max_stage?
    stage == 6
  end

  def min_stage?
    stage == -6
  end

  def stat_variation_message(target, stages)
    text = {
      1 => "rose!",
      2 => "sharply rose!",
      3 => "drastically rose!",
      -1 => "fell!",
      -2 => "harshly fell!",
      -3 => "severely fell!"
    }
    
    puts "#{target.name}'s #{name} #{text[stages]}"
  end


  def calc_value(lvl)
    if combat_stat?
      @initial_value = @base_value
      @curr_value = @base_value
    else
      stat_complement = hp? ? (lvl + 5) : 0
      common_formula = ( ( ( ( 2 * @base_value + @iv + ( @ev / 4 )) * lvl ) / 100 ) + 5 )
      calculation = (common_formula + stat_complement) * @nature_value
      @initial_value = calculation
      @curr_value = calculation
    end
  end

  def reset_stat
    return if hp?
    @curr_value = @initial_value
    @stage = 0
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
end
