require_relative "volatile_status"

class TransformedStatus < VolatileStatus
  def self.get_transformed(pokemon)
    new(
      name: :transformed,
      data: previous_attributes(pokemon)
      )
  end

  def self.previous_attributes(pokemon)
    {
      types: pokemon.types.dup,
      # weight: pokemon.weight.dup,
      gender: pokemon.gender.dup,
      attacks: pokemon.attacks.dup,
      stats: pokemon.stats.dup
    }
  end

  def migrate_attributes(pokemon, pokemon_target)
    pokemon.types = pokemon_target.types
    # pokemon.weight = pokemon_target.weight
    pokemon.gender = pokemon_target.gender
    migrate_attacks(pokemon, pokemon_target)
    migrate_stats(pokemon, pokemon_target)
    pokemon.metadata[:crit_stage] = pokemon_target.metadata[:crit_stage]
  end

  def migrate_attacks(pokemon, pokemon_target)
    attack_transfer = []
    pokemon_target.attacks.each do |attack|
      attack_transfer << attack.dup 
    end
    pokemon.attacks.clear

    attack_transfer.each do |attack|
      pokemon.attacks << attack
    end

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