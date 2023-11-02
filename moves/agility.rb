require_relative "moves"
require_relative "concerns/move_modifiers"

class AgilityMove < Move
  include StatChanges

  def self.learn
    new(  attack_name: :agility,
          type: Types::NORMAL,
          category: :status,
        )
  end

  private
  def status_effect
    stat_changes
  end

  def stat
    [
      [:spd, 2]
    ]
  end
end