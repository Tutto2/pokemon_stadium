require_relative "move"

class CurseMove < Move
  include StatChanges
  # Different effect depending on the poke type

  def self.learn
    new(
      attack_name: :curse,
      type: Types::GHOST,
      pp: 10,
      category: :status
      )
  end

  private
  def status_effect
    stat_changes
  end

  def stat
    [
      [:atk, 1],
      [:def, 1],
      [:spd, -1]
    ]
  end
end