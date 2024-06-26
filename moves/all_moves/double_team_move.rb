require_relative "../move"

class DoubleTeamMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: 'Double Team',
      type: Types::NORMAL,
      pp: 15,
      category: :status
      )
  end

  private
  def status_effect(pokemon_target)
    stat_changes
  end

  def stat
    [
      [:evs, 1]
    ]
  end
end
