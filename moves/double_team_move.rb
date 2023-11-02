require_relative "moves"
require_relative "concerns/move_modifiers"

class DoubleTeamMove < Move
  include StatChanges

  def self.learn
    new(  attack_name: :double_team,
          type: Types::NORMAL,
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