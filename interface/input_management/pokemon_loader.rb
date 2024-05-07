require 'json'

class PokemonLoader
  attr_accessor :pokemons, :file_url

  def initialize(file_url)
    @file_url = file_url
    @pokemons = []
  end

  def process
    pokemon = {}

    File.readlines(file_url).each do |line|
      next if line.chomp.strip! == "Stats:"
      
      if /^(\w+)(-\w+)*$/ =~ line
        if !pokemon[:name].nil?
          pokemons << pokemon
          pokemon = {}
        end
        pokemon[:name] = line.capitalize
      elsif /^Types: (?<type1>\w+)( \/ (?<type2>\w+))?$/ =~ line
        pokemon[:types] = [type1.upcase, type2.upcase].compact
      elsif /^(?<stat>\w+): (?<num>\d+)$/ =~ line
        pokemon[stat.sym] = num
      end
    end
  end

  def write
    File.open('all_pokemons.rb', 'w') do |file|
      file.puts JSON.pretty_generate(pokemons)
    end
  end
end

file = PokemonLoader.new('pokemonlist.dat')
file.process
file.write