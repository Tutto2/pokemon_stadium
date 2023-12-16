require_relative "move"

class BitterMaliceMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(
      attack_name: :bitter_malice,
      type: Types::GHOST,
      pp: 10,
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