require_relative "move"

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