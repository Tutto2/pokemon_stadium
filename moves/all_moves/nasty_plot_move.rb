require_relative "move"

class NastyPlotMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: 'Nasty Plot',
      type: Types::DARK,
      pp: 20,
      category: :status
      )
  end

  private
  def status_effect(pokemon_target)
    stat_changes
  end

  def stat
    [
      [:sp_atk, 2]
    ]
  end
end
