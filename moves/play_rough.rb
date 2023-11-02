require_relative "moves"
require_relative "concerns/move_modifiers"

class PlayRoughMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :play_rough,
          type: Types::FAIRY,
          category: :physical,
          precision: 90,
          power: 90
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

  def trigger_chance
    0.1
  end
end