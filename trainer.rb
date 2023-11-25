require_relative "actions/menu"

class Trainer
  attr_accessor :name, :team, :current_pokemon, :action

  def initialize(name:)
    @name = name
    @team = []
    @current_pokemon = nil
    @action = nil
  end

  def self.select_name(index)
    print "Player #{index}, select your name: "
    name = gets.chomp

    return Trainer.new(name: name) if !name.empty? && name.length < 10
    puts "Invalid input, the name must be less than 10 characters"
    select_name(index)
  end

  def team_build(pokemons)
    print "#{name} select a set of pokemon to battle: "
    @team.clear
    selection = gets.chomp.split.map(&:to_i)

    if selection.all? { |pick| (1..pokemons.size).include?(pick) } && (1..6).include?(selection.size)
      @team = selection.map { |pick| pokemons[pick-1] }
    else
      puts "Pick 1 to 6 pokemons, and provide valid indices. Try again."
      team_build(pokemons)
    end
  end

  def select_action(players)
    opponents = players.reject { |player| player == self }
    previous_atk = action&.behaviour

    @action = Menu.select_action(self, previous_atk, current_pokemon, opponents)
  end
end