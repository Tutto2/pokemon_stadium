require_relative "../move"

class PlayRoughMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(
      attack_name: 'Play Rough',
      type: Types::FAIRY,
      pp: 10,
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
