require_relative "move"

class GyroBallMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Gyro Ball',
      type: Types::STEEL,
      pp: 5,
      category: :physical
      )
  end

  def power
    [150, ( ( 25 * pokemon_target.spd_value ) / pokemon.spd_value ) + 1 ].min.to_i
  end
end
