require_relative "volatile_status"

class SeededStatus < VolatileConditions
  def self.get_seeded(opponent)
    new(
      name: :seeded,
      data: opponent
      )
  end

  def dmg_effect(pokemon)
    value = (pokemon.hp_total) * ( 1.0 / 8.0 )
    puts "#{pokemon.name} health is sapped by Leech Seed! (#{value.to_i})"
    pokemon.hp.decrease(value.to_i)
    data.current_pokemon.hp.increase(value.to_i)
  end
end