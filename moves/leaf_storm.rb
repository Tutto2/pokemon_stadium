require_relative "moves"
require_relative "concerns/move_modifiers"

class LeafStormMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :leaf_storm,
          type: Types::GRASS,
          category: :special,
          precision: 90,
          power: 130
        )
  end

  private
  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:sp_atk, -2]
    ]
  end
end