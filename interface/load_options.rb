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
    # Se rompe cuando no encuentra un poke. Solucionar
    MessagesPool.load_team_msg
    file_name = gets.chomp
    raise(StandardError, "File doesn't exist") unless File.exist?("interface/input_management/#{file_name}.pkteam")
    file = TeamDeserializer.new(File.join('interface', 'input_management', "#{file_name}.pkteam"))
    file.process
    file.upload
    MessagesPool.successful_load_msg
  rescue Errno::ENOENT, StandardError
    MessagesPool.loading_error(file_name)
  rescue ArgumentError
    MessagesPool.reading_error
  ensure
    load_interface
  end

  def self.view_teams
    data_manager = DataManager.new

    if data_manager.get_teams_data
      data_manager.view_teams_simple
      MessagesPool.view_team_index
      index = gets.chomp.to_i

      if (1..data_manager.all_teams.count).include?(index)
        data_manager.view_team_detailed(index)
      end
    end
    puts
    load_interface
  end

  def self.load_pokemons
    MessagesPool.load_pokemons_msg
    file_name = gets.chomp

    file = PokemonLoader.new("interface/input_management/#{file_name}.dat")
    file.process
    file.upload
    MessagesPool.successful_load_msg
  rescue Errno::ENOENT
    MessagesPool.loading_error(file_name)
  rescue ArgumentError
    MessagesPool.reading_error
  ensure
    load_interface
  end
end
