require_relative "trainer"
require_relative "pokedex/pokedex"
require_relative "moves/move"
require_relative "action"
require_relative "menu"
require "pry"
# binding.pry

class PokemonBattleField
  attr_reader :players, :all_pokes, :current_pokemon_p1, :current_pokemon_p2

  def self.init_game(pokemons)
    print "Player one, select your name: "
    player_one = Trainer.new(name: gets.chomp)

    print "Player two, select your name: "
    player_two = Trainer.new(name: gets.chomp)

    battlefield = PokemonBattleField.new(
      players: [player_one, player_two],
      all_pokes: pokemons
    )

    battlefield.choose_pokemons
  end

  def initialize(players: [], all_pokes: [])
    @players = players
    @all_pokes = all_pokes
  end

  def choose_pokemons
    view_pokemons(all_pokes)
    players.each do |player|
      player.team_build(all_pokes)
    end
    start_battle
  end

  def start_battle
    $turn = 1
    select_initial_pok(players)

    loop do
      break if players.any? { |player| team_fainted?(player) }
      puts
      puts "############ turn #{$turn} ############"
      players.each do |player| 
        if player.current_pokemon.fainted?
          player.current_pokemon = player.team[selection_index(player)]
        end
      end

      display_pokemons
      players.each { |player| player.action = player.select_action }

      queue = ActionQueue.new
      players.each { |player| queue.priority_queue << player.action }
      perform_actions(queue)
      $turn += 1
    end

    return 'Player two wins!' if pokemons_p1.all?(&:fainted?)
    return 'Player one Wins!' if pokemons_p2.all?(&:fainted?)
  end

  private

  def view_pokemons(pokemons)
    pokemons.each.with_index(1) do |pok, index|
      puts "#{index}- #{pok.to_s}" if !pok.fainted?
    end
  end

  def select_initial_pok(players)
    players.each do |player|
      player.current_pokemon = player.team[selection_index(player)]
    end
  end

  def selection_index(player)
    view_pokemons(player.team)
      
    print "#{player.name} select your initial pokemon: "
    index = gets.chomp.to_i

    return (index - 1) if index > 0 && index <= player.team.size
      
    puts "Invalid option. Try again"
    return selection_index(player)
  end

  def team_fainted?(player)
    player.team.all?(&:fainted?)
  end

  def display_pokemons
    players.each do |player|
      puts "#{player.name}'s pokemon:"
      puts player.current_pokemon.status
    end
  end

  def perform_actions(queue)
    queue.priority_table.each do |index, action|
      if action.size == 1
        action.perform_action
      elsif action != empty?
        actions = []
        action.each do |action|
          if actions.empty?
            actions << action 
          else
            action.speed > actions[0].speed ? actions.unshift(action) : actions << action
          end
        end
        actions.each(&perform)
      end
    end
  end

  def perform
    ->(action) { action.perform_action }
  end
  
  def go_back(list)
    puts "#{ (list.length) + 1 }- Go back"
    puts
  end

  def alive?
    ->(pokemon) { !pokemon.fainted?}
  end
end

pokemons = [
  Pokedex.catch("Kommo-o"),
  Pokedex.catch("Mew"),
  Pokedex.catch("Snorlax"),
  Pokedex.catch("Dragapult"),
  Pokedex.catch("Sceptile"),
  Pokedex.catch("Milotic"),
  Pokedex.catch("Golem"),
  Pokedex.catch("Pikachu"),
  Pokedex.catch("Squirtle"),
  Pokedex.catch("Baxcalibur"),
  Pokedex.catch("Ogerpon"),
  Pokedex.catch("Tinkaton"),
  Pokedex.catch("Gengar"),
  Pokedex.catch("Ceruledge"),
  Pokedex.catch("Poltchageist"),
  Pokedex.catch("Gholdengo"),
  Pokedex.catch("Dracanfly"),
  Pokedex.catch("Zoroark-hisui")
      ]

puts PokemonBattleField.init_game(pokemons)