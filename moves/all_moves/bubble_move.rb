require_relative "../move"

class BubbleMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(
      attack_name: 'Bubble',
      type: Types::WATER,
      pp: 30,
      category: :special,
      power: 40,
      target: 'all_opps'
      )
  end

  private
  def secondary_effect
    stat_changes(pokemon_target)
  end

  def trigger_chance
    0.1
  end

  def stat
    [
      [:spd, -1]
    ]
  end
end