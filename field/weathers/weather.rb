class Weather
  attr_reader :name, :duration, :harm, :immune_types, :enhanced_types, :decreased_types, :turn

  def initialize(name:, duration: nil, harm: nil, immune_types: nil, enhanced_types: nil, decreased_types: nil, turn:)
    @name = name
    @duration = duration
    @harm = harm
    @immune_types = immune_types
    @enhanced_types = enhanced_types
    @decreased_types = decreased_types
    @turn = turn
  end

  def count_weather_turn
    @turn += 1
  end
end