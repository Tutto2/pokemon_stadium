require_relative "../move"

class FlameChargeMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(
      attack_name: 'Flame Charge',
      type: Types::FIRE,
      pp: 20,
      category: :physical,
      power: 50
      )
  end

  private
  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:spd, 1]
    ]
  end

  def trigger_chance
    1
  end
end
