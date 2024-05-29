curr_dir = File.dirname(__FILE__)
weather_folder_path = File.join(curr_dir, '/weathers')
weather_paths = Dir.glob(File.join(weather_folder_path, '*.rb'))

weather_paths.each do |weather|
  require_relative weather
end

class Field
  attr_accessor :positions, :weather, :field_hazards

  def initialize(positions: {}, weather: nil, field_hazards: nil)
    @positions = positions
    @weather = weather
    @field_hazards = field_hazards
  end

  def any_pokemon_fainted?
    positions.any? { |_, pok| pok.fainted? }
  end

  def apply_weather(new_weather)
    BattleLog.instance.log(MessagesPool.weather_apply_msg(new_weather.name))
    @weather = new_weather
  end
end