require_relative "../move"

class RockSlideMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include CanFlinch

  def self.learn
    new(
      attack_name: 'Rock Slide',
      type: Types::ROCK,
      pp: 15,
      category: :physical,
      power: 75,
      precision: 90,
      target: 'all_opps'
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
