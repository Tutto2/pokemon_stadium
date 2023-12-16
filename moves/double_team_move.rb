require_relative "move"

class DoubleTeamMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: :double_team,
      type: Types::NORMAL,
      pp: 15,
      category: :status
      )
  end

  private
  def status_effect
    stat_changes
  end

  def stat
    [
      [:evs, 1]
    ]
  end
end