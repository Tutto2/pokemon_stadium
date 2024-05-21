require_relative "../move"

class MoonblastMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(
      attack_name: 'Moonblast',
      type: Types::FAIRY,
      pp: 15,
      category: :special,
      power: 95
      )
  end

  private
  def secondary_effect
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:sp_atk, -1]
    ]
  end

  def trigger_chance
    0.3
  end
end