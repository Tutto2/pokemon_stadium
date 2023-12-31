require_relative "move"

class NastyPlotMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: :nasty_plot,
      type: Types::DARK,
      pp: 20,
      category: :status
      )
  end

  private
  def status_effect
    stat_changes
  end

  def stat
    [
      [:sp_atk, 2]
    ]
  end
end