require_relative "moves"
require_relative "concerns/move_modifiers"

class PsychicMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(  attack_name: :psychic,
          type: Types::PSYCHIC,
          category: :special,
          power: 90
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
    0.1
  end
end