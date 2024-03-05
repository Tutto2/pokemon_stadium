require_relative "move"

class MakeItRainMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(
      attack_name: :make_it_rain,
      type: Types::STEEL,
      pp: 5,
      category: :special,
      power: 120,
      target: 'all_opps'
      )
  end

  private
  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:sp_atk, -1]
    ]
  end
end