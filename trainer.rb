require_relative "menu"

class Trainer
  attr_accessor :name, :team, :current_pokemon, :action

  def initialize(name: nil, team: [], current_pokemon: nil, action: nil)
    @name = name
    @team = team
    @current_pokemon = current_pokemon
    @action = action
  end
  
  def team_build(pokemons)
    print "#{name} select a set of pokemon to battle: "
    @team.clear
    selection = gets.chomp.split
    selection = selection.map { |x| x.to_i }

    if !selection.empty? && (1..6).include?(selection.size)
      selection.each do |pick|
        if (1..(pokemons.size)).include?(pick) 
          @team.push(pokemons[pick-1])
        else 
          puts "Write the index (1 - #{pokemons.size}) of each pokemon you want"
          return team_build(pokemons)
        end
      end
    else
      puts "Pick 1 to 6 pokemons, try again"
      return team_build(pokemons)
    end
  end

  def select_action
    previous_atk = action
    @action = Menu.select_action(self, previous_atk, current_pokemon)
  end
end