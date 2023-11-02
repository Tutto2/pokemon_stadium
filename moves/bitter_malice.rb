require_relative "moves"
require_relative "concerns/move_modifiers"

class BitterMaliceMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges
  # Cause frostbite

  def self.learn
    new(  attack_name: :bitter_malice,
          type: Types::GHOST,
          category: :special,
          power: 80,
        )
  end

  private
  def secondary_effect
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:atk, -1]
    ]
  end
end