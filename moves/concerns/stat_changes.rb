require_relative "../move"

module StatChanges
  def stat_changes(target = pokemon)
    pokemon.successful_perform

    return protected_itself if target == :pokemon_target && protected?
    stat.each do |(stat, stages)|
      target.public_send(stat).stage_modifier(target, stages)
    end
  end

  private
  def stat; end
end