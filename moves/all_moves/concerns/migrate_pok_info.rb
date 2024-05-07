require_relative "../../move"

module MigratePokInfo
  def migrate_stat_stages(pokemon_target)
    stages = []
    pokemon_target.stats.each do |stat|
      stages << stat.stage unless stat.hp?
    end
    pokemon.stats.each do |stat|
      stat.stage = stages.shift unless stat.hp?
    end

    pokemon.stats.each { |stat| stat.in_game_stat_calc }
    pokemon_target.metadata[:crit_stage] = pokemon.metadata[:crit_stage]
  end
end