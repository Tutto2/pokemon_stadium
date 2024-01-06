require_relative "volatile_status"

class TransformedStatus < VolatileConditions
  def self.get_transformed(pokemon, pokemon_target)
    new(
      name: :transformed,
      data: previous_attributes(pokemon)
      )
  end

  def self.previous_attributes(pokemon)
    {
      types: pokemon.types.dup,
      weight: pokemon.weight.dup,
      gender: pokemon.gender.dup,
      attacks: pokemon.attacks.dup,
      stats: pokemon.stats.dup
    }
  end

  def migrate_attributes(pokemon, pokemon_target)
    pokemon.types = pokemon_target.types.dup
    pokemon.weight = pokemon_target.weight.dup
    pokemon.gender = pokemon_target.gender.dup
    migrate_attacks(pokemon, pokemon_target)
    migrate_stats(pokemon, pokemon_target)
    pokemon_target.metadata[:crit_stage] = pokemon.metadata[:crit_stage]
  end

  def migrate_attacks(pokemon, pokemon_target)
    pokemon.attacks = pokemon_target.attacks.dup
    pokemon.attacks.each { |atk| atk.pp = 5 }
  end

  def migrate_stats(pokemon, pokemon_target)
    stats_transfer = []
    pokemon_target.stats.each do |stat|
      stats_transfer << stat.dup unless stat.hp?
    end
    pokemon.stats.each_with_index do |stat, index|
      pokemon.stats[index] = stats_transfer.shift unless stat.hp?
    end
  end
end