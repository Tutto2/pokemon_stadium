require_relative "moves"
require_relative "concerns/move_modifiers"

class SolarBladeMove < Move
  include BasicPhysicalAtk
  # Charge one turn
  # Agregar tipo fuego?

  def self.learn
    new(  attack_name: :solar_blade,
          type: Types::GRASS,
          category: :physical,
          power: 125
        )
  end
end