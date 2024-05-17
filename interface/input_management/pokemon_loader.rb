require_relative '../data_manager'
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
        pokemon[:name] = line.chomp.capitalize
      elsif /^Types: (?<type1>\w+)( \/ (?<type2>\w+))?$/ =~ line
        pokemon[:types] = [type1, type2].compact.map(&:upcase)
      elsif /^(?<stat>\w+): (?<num>\d+)$/ =~ line
        pokemon[stat.to_sym] = num
      end
    end
  end

  def write
    File.open('interface/input_management/all_pokemons.rb', 'w') do |file|
      file.puts JSON.pretty_generate(pokemons)
    end
  end

  def upload
    data_manager = DataManager.new

    uploaded_pokemon = data_manager.get_pokemon_templates
    return if uploaded_pokemon.nil?

    uploaded_pokemon.map! { |pok| pok["name"] }
    new_pokemons = pokemons.select { |pokemon| !uploaded_pokemon.include?(pokemon[:name]) }

    new_pokemons.each do |pokemon|
      data_manager.upload_pokemons({pokemon_template: pokemon})
    end
  end
end
