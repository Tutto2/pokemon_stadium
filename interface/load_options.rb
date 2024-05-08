require_relative 'data_manager'
require_relative 'input_management/team_deserializer'
require_relative 'input_management/pokemon_loader'

class LoadOptions
  def self.load_interface
    index = 0
    MessagesPool.loading_index

    loop do
      MessagesPool.select_first_action
      index = gets.chomp.to_i

      break if (1..4).include?(index)
      MessagesPool.invalid_option
    end

    return PokemonBattleApp.new_game if index == 4

    case index
    when 1 then load_team
    when 2 then view_teams
    when 3 then load_pokemons
    end
  end

  def self.load_team
    file = nil
    file_name = ''
    MessagesPool.load_team_msg
    file_name = gets.chomp

    begin
      file = TeamDeserializer.new("interface/input_management/#{file_name}.pkteam")
      file.process
    rescue Errno::ENOENT
      MessagesPool.loading_error(file_name)
      return load_interface
    rescue ArgumentError
      MessagesPool.reading_error 
      return load_interface
    end

    file.write
    MessagesPool.successful_load_msg
    load_interface
  end

  def self.view_teams
    data = DataManager.view_teams_simple

    unless data.empty?
      MessagesPool.view_team_index 
      index = gets.chomp.to_i
      return load_interface if index == 0

      DataManager.view_team_detailed(index)
    else
      MessagesPool.view_team_error 
    end
    load_interface
  end

  def self.load_pokemons
    file = nil
    file_name = ''
    MessagesPool.load_pokemons_msg
    file_name = gets.chomp

    begin
      file = PokemonLoader.new("interface/input_management/#{file_name}.dat")
      file.process
    rescue Errno::ENOENT
      MessagesPool.loading_error(file_name)
      return load_interface
    rescue ArgumentError
      MessagesPool.reading_error
      return load_interface
    end

    file.write
    MessagesPool.successful_load_msg
    load_interface
  end
end

