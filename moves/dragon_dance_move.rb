require_relative "move"

class DragonDanceMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: 'Dragon Dance',
      type: Types::DRAGON,
      pp: 20,
      category: :status
      )
  end

  private
  def status_effect(pokemon_target)
    stat_changes
  end

  def stat
    [
      [:atk, 1],
      [:spd, 1]
    ]
  end
end
