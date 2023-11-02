require_relative "moves"
require_relative "concerns/move_modifiers"

class ClangingScalesMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :clanging_scales,
          type: Types::DRAGON,
          category: :special,
          power: 110
        )
  end

  private
  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:def, -1]
    ]
  end
end