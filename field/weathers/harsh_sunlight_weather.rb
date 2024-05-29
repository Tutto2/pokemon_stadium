require_relative "weather"

class HarshSunlight < Weather
  def initialize
    @name = :harsh_sunlight
    @duration = 5
    @enhanced_types = Types::FIRE
    @decreased_types = Types::WATER
  end
end