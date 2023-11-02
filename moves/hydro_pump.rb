require_relative "moves"

class HydroPumpMove < Move
  include BasicSpecialAtk

  def self.learn
    new(  attack_name: :hydro_pump,
          type: Types::WATER,
          category: :special,
          precision: 80,
          power: 120
        )
  end
end