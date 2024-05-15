require_relative "../move"

class EarthquakeMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Earthquake',
      type: Types::GROUND,
      pp: 10,
      category: :physical,
      power: 100,
      target: 'all_except_self'
      )
  end
end
