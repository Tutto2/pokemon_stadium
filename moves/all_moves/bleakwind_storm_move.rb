require_relative "../move"

class BleakwindStormMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Bleakwind Storm',
      type: Types::FLYING,
      pp: 10,
      category: :special,
      power: 100,
      precision: 80,
      target: 'all_opps'
      )
  end

  def secondary_effect
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:spd, -1]
    ]
  end

  def trigger_chance
    0.3
  end
end