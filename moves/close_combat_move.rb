require_relative "move"


class CloseCombatMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :close_combat,
          type: Types::FIGHTING,
          category: :physical,
          power: 120
        )
  end

  private
  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:sp_def, -1],
      [:def, -1]
    ]
  end
end