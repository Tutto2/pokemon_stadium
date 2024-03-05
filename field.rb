require_relative "pokemon/pokemon"

class Field
  attr_accessor :positions, :weather, :field_conditions

  def initialize(positions: {}, weather: nil, field_conditions: nil)
    @positions = positions
    @weather = weather
    @field_conditions = field_conditions
  end

  def any_pokemon_fainted?
    positions.any? { |_, pok| pok.fainted? }
  end
end