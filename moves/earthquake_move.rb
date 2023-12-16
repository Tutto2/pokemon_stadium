require_relative "move"

class EarthquakeMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: :earthquake,
      type: Types::GROUND,
      pp: 10,
      category: :physical,
      power: 100
      )
  end
end