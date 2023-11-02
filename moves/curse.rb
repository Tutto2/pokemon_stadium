require_relative "moves"
require_relative "concerns/move_modifiers"

class CurseMove < Move
  include StatChanges
  # Different effect depending on the poke type

  def self.learn
    new(  attack_name: :curse,
          type: Types::GHOST,
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