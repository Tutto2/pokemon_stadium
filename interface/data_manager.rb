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
  attr_accessor :all_teams

  def initialize; end

  def get_teams_data
    response = HTTParty.get("http://localhost:3000/teams?view=detailed")
    if response.success?
      @all_teams = response.parsed_response
      all_teams.any?
    end
  rescue Errno::ECONNREFUSED
    puts "Couldn't enable connection to the server"
  end

  def get_single_team_data(index)
    team_id = all_teams[index - 1]["id"]
    HTTParty.get("http://localhost:3000/teams/#{team_id}?view=detailed")
  rescue Errno::ECONNREFUSED
    puts
    puts "Couldn't enable connection to the server"
  rescue Errno::ENOENT
    puts
    puts "Team not found"
  end

  def view_teams_simple
    all_teams.each.with_index(1) do |team, index|
      puts
      puts "#{index}- #{team["name"]}:"

      team["pokemons"].each do |pok|
        names = pok["nickname"] == pok["name"] || pok["nickname"].nil? ? " -- #{pok["name"]}, " : " -- #{pok["nickname"]} (#{pok["name"]}), "
        types = pok["types"][1] ? "#{pok["types"][0].upcase} / #{pok["types"][1].upcase}" : "#{pok["types"][0].upcase}"
        moves = "    > Moves: "

        pok["moves"].each.with_index do |move, index|
          if index == 0
            moves += move
          else
            moves += ", " + move
          end
        end
        moves += "."

        puts names + types
        puts moves
      end
    end
  end

  def view_team_detailed(index)
    team  = get_single_team_data(index).parsed_response

    puts
    unless team.nil?
      puts "#{team["name"]}:"
      team["pokemons"].each { |pok| print_pokemon_info(pok) }
    end
  end

  def print_pokemon_info(pok)
    types = pok["types"][1] ? "  Types: #{pok["types"][0]} #{pok["types"][1]}" : "  Type: #{pok["types"][0]}"

    puts "- #{pok["name"]}"
    puts "  Nickname: #{pok["nickname"]}" if pok["nickname"]
    puts types
    puts "  Nature: #{pok["nature"]}" if pok["nature"]
    puts "  Gender: #{pok["gender"]}" if pok["gender"]
    puts "  Stats: #{pok["stats"].map { |stat, value| "#{stat}: #{value}" }.join(', ') }"
    puts "  IVs: #{pok["ivs"].join(', ')}"
    puts "  EVs: #{pok["evs"].join(', ')}"
    puts "  Moves: #{pok["moves"].join(', ')}"
    puts
end

  def get_pokemon_templates
    HTTParty.get("http://localhost:3000/pokemon_templates").parsed_response
  rescue Errno::ECONNREFUSED
    puts "Couldn't enable connection to the server"
  end

  def team_converter(index)
    team  = get_single_team_data(index).body
    parsed_team = JSON.parse(team, symbolize_names: true)
    converted_team = []

    parsed_team[:pokemons].each do |pok|
      moves_array = []
      pok[:moves].map do |move|
        name = move.scan(/[\w]+/).join("_")
        camelized_name = "#{name}_move".camelize
        if Object.const_defined?(camelized_name)
          moves_array << camelized_name.constantize.learn 
        else
          puts "#{camelized_name} NOT DEFINED"
        end
      end

      converted_team << Pokemon.new(
        name: pok[:name],
        nickname: pok[:nickname],
        types: pok[:types].map! { |type| "Types::#{type.upcase}".constantize },
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

  def upload_pokemons(pokemon)
    HTTParty.post("http://localhost:3000/pokemon_templates", body: JSON.generate(pokemon), headers: { 'Content-Type' => 'application/json' })
  end

  def create_team(team)
    HTTParty.post("http://localhost:3000/teams", body: JSON.generate(team), headers: { 'Content-Type' => 'application/json' })
  end
end
