require_relative "move"

class AgilityMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: :agility,
      type: Types::NORMAL,
      pp: 30,
      category: :status,
      )
  end

  private
  def status_effect(pokemon_target)
    stat_changes
  end

  def stat
    [
      [:spd, 2]
    ]
  end
end