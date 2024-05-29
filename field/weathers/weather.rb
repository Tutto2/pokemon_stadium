class Weather
  def initialize(name:, duration: nil, harm: nil, immune_types: nil, enhanced_types: nil, decreased_types: nil)
    @name = name
    @duration = duration
    @harm = harm
    @immune_types = immune_types
    @enhanced_types = enhanced_types
    @decreased_types = decreased_types
    @turn = 0
  end

  def count_weather_turn
    @turn += 1
  end
end