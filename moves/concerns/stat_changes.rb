require_relative "../move"

module StatChanges
  def stat_changes(target = pokemon)
    stat.each do |(stat, stages)|
      target.public_send(stat).stage_modifier(target, stages)
    end
    pokemon.successful_perform
  end

  private
  def stat; end
end