require_relative "weather"

class HarshSunlight < Weather
  def initialize
    @name = 'Harsh sunlight'
    @duration = 5
    @enhanced_types = [Types::FIRE]
    @decreased_types = [Types::WATER]
    @turn = 0
  end
end