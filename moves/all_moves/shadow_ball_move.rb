require_relative "../move"

class ShadowBallMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(
      attack_name: 'Shadow Ball',
      type: Types::GHOST,
      pp: 15,
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
