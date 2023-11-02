require_relative "moves"
require_relative "concerns/move_modifiers"

class GyroBallMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(  attack_name: :gyro_ball,
          type: Types::STEEL,
          category: :physical,
        )
  end

  private

  def power
    [150, ( ( 25 * pokemon_target.spd_value ) / pokemon.spd_value ) + 1 ].min.to_i
  end
end