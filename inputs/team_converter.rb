require 'json'

lines = File.readlines('mancha-team.pkteam').flatten

def array_managment(array, default = 0)
  stats = [:hp, :atk, :def, :spa, :spd, :spe].zip([default]*6).to_h

  array.scan(/(\d+) (\w+)/).each do |(num, stat)|
    stats[stat.downcase.to_sym] = num.to_i
  end

  stats.values
end

def initialize_stats_if_empty(pokemons, stat_key, default_value)
  pokemons.each do |pok|
    if pok[stat_key].empty?
      6.times do
        pok[stat_key] << default_value
      end
    end
  end
end

File.open('team_output.rb', 'w') do |file|
  data = {}
  pokemon_index = -1
  pokemons = []

  lines.each do |line|
    line.strip!
    if /\ATeam: (?<team_name>[\w ]+)\z/ =~ line
      data[:team] = team_name
    elsif /\A(?<name1>\w+)(?: \((?<name2>\w+)\))?\z/ =~ line
      name = name2 || name1
      nickname = name2 ? name1 : nil
      pokemons << {name: name, nickname: nickname, teratype: nil, ivs: [], evs: [], nature: nil, moves: []}
      pokemon_index += 1
    elsif /\ATera Type: (?<teratype>[\w ]+)\z/ =~ line
      pokemons[pokemon_index][:teratype] = teratype
    elsif /\AEVs: (?<evs>\d+ \w+( \/ \d+ \w+){,5})\z/ =~ line
      pokemons[pokemon_index][:evs] = array_managment(evs)
    elsif /\AIVs: (?<ivs>\d+ \w+( \/ \d+ \w+){,5})\z/ =~ line
      pokemons[pokemon_index][:ivs] = array_managment(ivs, 31)
    elsif /\A(?<nature>\w+) Nature\z/ =~ line
      pokemons[pokemon_index][:nature] = nature.downcase
    elsif /\A- (?<move>[\w ]+)/ =~ line
      pokemons[pokemon_index][:moves] << move
    end

    initialize_stats_if_empty(pokemons, :evs, 0)
    initialize_stats_if_empty(pokemons, :ivs, 31)
  end

  data[:pokemons] = pokemons

  file.puts JSON.pretty_generate(data)
end



# data.split(/spd:\s+\d{1,3}\n/)