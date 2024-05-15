require_relative '../data_manager'
require 'json'

class TeamDeserializer
  attr_accessor :team, :file_url

  def initialize(file_url)
    @file_url = file_url
    @team = {team: "", pokemons: []}
  end

  def process
    lines = File.readlines(file_url)
    pokemons = []
    pokemon_index = -1

    lines.each do |line|
      line.strip!
      if /\ATeam: (?<team_name>[\w ]+)\z/ =~ line
        team[:team] = team_name
      elsif /\A(?<name1>\w+)(?: \((?<name2>\w+)\))?\z/ =~ line
        name = name2 || name1
        nickname = name2 ? name1 : nil
        team[:pokemons] << {
          name: name,
          nickname: nickname,
          teratype: nil, 
          ivs: [31]*6, 
          evs: [0]*6,
          nature: nil,
          moves: []
        }
        pokemon_index += 1
      elsif /\ATera Type: (?<teratype>[\w ]+)\z/ =~ line
        team[:pokemons][pokemon_index][:teratype] = teratype.upcase
      elsif /\AEVs: (?<evs>\d+ \w+( \/ \d+ \w+){,5})\z/ =~ line
        team[:pokemons][pokemon_index][:evs] = array_managment(evs)
      elsif /\AIVs: (?<ivs>\d+ \w+( \/ \d+ \w+){,5})\z/ =~ line
        team[:pokemons][pokemon_index][:ivs] = array_managment(ivs, 31)
      elsif /\A(?<nature>\w+) Nature\z/ =~ line
        team[:pokemons][pokemon_index][:nature] = nature.downcase
      elsif /\A- (?<move>[\w -]+)/ =~ line
        team[:pokemons][pokemon_index][:moves] << move
      end
    end
  end

  def write
    File.open("interface/input_management/#{team[:team]}.rb", 'w') do |file|
      file.puts JSON.pretty_generate(team)
    end
  end

  def upload
    DataManager.new.create_team(team)
  end

  private

  def array_managment(array, default = 0)
    stats = [:hp, :atk, :def, :spa, :spd, :spe].zip([default]*6).to_h
  
    array.scan(/(\d+) (\w+)/).each do |(num, stat)|
      stats[stat.downcase.to_sym] = num.to_i
    end
  
    stats.values
  end
end