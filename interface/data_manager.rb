curr_dir = File.dirname(__FILE__)
moves_path = File.join(curr_dir, '..', 'moves/all_moves')
file_paths = Dir.glob(File.join(moves_path, '*.rb'))

require 'active_support/inflector'
require 'httparty'
require 'json'
require_relative '../pokemon/pokemon'
file_paths.each do |file_path|
  require_relative file_path
end

class DataManager
  attr_reader :all_teams

  def initialize
    begin
      @all_teams = HTTParty.get("http://localhost:3000/teams?view=detailed")
    rescue Errno::ECONNREFUSED
      puts "Couldn't enable connection to the server"
    end
  end

  def teams_data
    all_teams.parsed_response unless all_teams.nil?
  end

  def view_teams_simple
    all_teams.parsed_response.each.with_index(1) do |team, index|
      puts
      puts "#{index}- #{team["name"]}:"

      team["pokemons"].each do |pok|
        names = pok["nickname"] == pok["name"] ? " -- #{pok["name"]}, " : " -- #{pok["nickname"]} (#{pok["name"]}), " 
        types = pok["types"][1] ? "types: #{pok["types"][0]} #{pok["types"][1]}. " : "type: #{pok["types"][0]}. "
        moves = "Moves: "

        pok["moves"].each.with_index do |move, index|
          if index == 0
            moves += move 
          else
            moves += ", " + move
          end
        end
        moves += "."

        puts names + types + moves
      end
    end
  end

  def view_team_detailed(index)
    team_id = all_teams.parsed_response[index - 1]["id"]

    begin
      response = HTTParty.get("http://localhost:3000/teams/#{team_id}?view=detailed")
    rescue Errno::ECONNREFUSED
      puts "Couldn't enable connection to the server"
      return
    end

    team = response.parsed_response
    puts
    puts "#{team["name"]}:"
    team["pokemons"].each { |pok| print_pokemon_info(pok) }
  end

  def print_pokemon_info(pok)
      types = pok["types"][1] ? "  Types: #{pok["types"][0]} #{pok["types"][1]}" : "  Type: #{pok["types"][0]}"

      puts "- #{pok["name"]}"
      puts "  Nickname: #{pok["nickname"]}"
      puts types 
      puts "  Nature: #{pok["nature"]}"
      puts "  Gender: #{pok["gender"]}"
      puts "  Stats: #{pok["stats"].map { |stat, value| "#{stat}: #{value}" }.join(', ') }"
      puts "  IVs: #{pok["ivs"].join(', ')}"
      puts "  EVs: #{pok["evs"].join(', ')}"
      puts "  Moves: #{pok["moves"].join(', ')}"
      puts
  end

  def team_converter(index)
    team_id = all_teams.parsed_response[index - 1]["id"]

    data = HTTParty.get("http://localhost:3000/teams/#{team_id}?view=detailed").body
    team = JSON.parse(data, symbolize_names: true)
    converted_team = []

    team[:pokemons].each do |pok|
      moves_array = []
      pok[:moves].map do |move|
        name = move.scan(/[\w-]+/).join("_")
        camelized_name = "#{name}_move".camelize
        moves_array << camelized_name.constantize.learn if defined? move.constantize
      end


      
      # extraxted_moves = pok[:moves].map { |move| move.gsub(' ', '_') }
      # converted_moves = extraxted_moves.map { |move_name| "#{move_name}_move".camelize }
      # moves_array = converted_moves.map { |move| move.constantize.learn if defined? move.constantize }.compact

      converted_team << Pokemon.new(
        name: pok[:name],
        nickname: pok[:nickname],
        types: pok[:types],
        gender: pok[:gender],
        nature: pok[:nature],
        attacks: moves_array.compact,
        ivs: pok[:ivs],
        evs: pok[:evs],
        stats: pok[:stats].map { |stat, value| Stats.new(name: stat, base_value: value.to_i) }
      )
    end
    
    converted_team
  end
end