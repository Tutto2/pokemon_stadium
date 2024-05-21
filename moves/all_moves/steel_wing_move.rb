require_relative "../move"

class SteelWingMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(
      attack_name: 'Steel Wing',
      type: Types::STEEL,
      pp: 25,
      category: :physical,
      power: 70,
      precision: 90
      )
  end

  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:def, 1]
    ]
  end

  def trigger_chance
    0.1
  end
end