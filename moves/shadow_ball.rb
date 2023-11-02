require_relative "moves"
require_relative "concerns/move_modifiers"

class ShadowBallMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :shadow_ball,
          type: Types::GHOST,
          category: :special,
          power: 80
        )
  end

  private
  def secondary_effect
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:sp_def, -1]
    ]
  end

  def trigger_chance
    0.2
  end
end