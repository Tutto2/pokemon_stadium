require_relative "moves"
require_relative "concerns/move_modifiers"

class DragonDanceMove < Move
  include StatChanges

  def self.learn
    new(  attack_name: :dragon_dance,
          type: Types::DRAGON,
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
      [:spd, 1]
    ]
  end
end