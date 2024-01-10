require_relative "../move"

module HpChange
  def lose_hp(target = pokemon, value)
    return puts "The attack has failed." if target.hp_value <= value
    target.hp.decrease(value.to_i)
    puts "#{target} has lost #{value.to_i} hp"
    pokemon.successful_perform
  end

  def gain_hp(target = pokemon, value)
    initial_hp = target.hp_value
    return puts "It has no effect on #{target.name}'s HP" if initial_hp.to_i == target.hp_total.to_i
    target.hp.increase(value).to_i
    puts "#{target.name} has recover #{(target.hp_value) - (initial_hp)} hp"
    pokemon.successful_perform
  end

  private
  def value; end
end