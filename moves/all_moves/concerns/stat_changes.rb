require_relative "../../move"

module StatChanges
  def stat_changes(target = pokemon)
    pokemon.successful_perform

    return protected_itself(pokemon_target) if target == pokemon_target && protected?(pokemon_target)
    stat.each do |(stat, stages)|
      target.public_send(stat).stage_modifier(target, stages)
    end
  end

  private
  def stat; end
end