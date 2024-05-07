require_relative "../move"

class HydroPumpMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: 'Hydro Pump',
      type: Types::WATER,
      pp: 5,
      category: :special,
      precision: 80,
      power: 120
      )
  end
end
