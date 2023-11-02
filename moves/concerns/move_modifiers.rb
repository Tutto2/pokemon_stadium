require_relative "../moves"

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
      return power if range.include?(calculation_stat)
    end
  end

  private
  def calculation_stat; end

  def table; end
end

module HpChange
  def lose_hp(target = pokemon)
    return puts "The attack has failed." if target.hp_value <= value
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

module TypeChange
  private
  def type; end
end
