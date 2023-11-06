require_relative "../move"

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