require_relative "volatile_status"

class CurseStatus < VolatileConditions
  def self.get_cursed(pokemon, pokemon_target)
    puts "#{pokemon.name} cut his own HP and laid a curse on #{pokemon_target.name}"

    new(
      name: :cursed, 
      )
  end

  def dmg_effect(pokemon)
    value = (pokemon.hp_total) * ( 1.0 / 4.0 )
    puts "#{pokemon.name} is afflicted by the curse! (#{value.to_i})"
    pokemon.hp.decrease(value.to_i)
  end
end