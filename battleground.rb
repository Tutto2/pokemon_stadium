require_relative "trainer"
require_relative "actions/menu"
require_relative "actions/action_queue"
require_relative "pokedex/pokedex"
require "pry"
# binding.pry

class PokemonBattleField
  attr_reader :players, :all_pokes

  def self.init_game(players_num, pokemons)
    players = select_players_names(players_num)

    battlefield = PokemonBattleField.new(
      players: players,
      all_pokes: pokemons
    )

    battlefield.choose_pokemons
  end

  def self.select_players_names(players_num)
    (1..players_num).map do |index|
      Trainer.select_name(index.to_s)
    end
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
    @turn = 1
    select_initial_pok(players)

    loop do
      break if players.any? { |player| team_fainted?(player) }
      puts
      puts "############ turn #{@turn} ############"
      players.each do |player| 
        if player.current_pokemon.fainted?
          player.current_pokemon = player.team[selection_index(player)]
          puts
        end
      end

      display_pokemons
      players.each { |player| player.select_action(players) }

      queue = ActionQueue.new
      players.each { |player| queue << player.action }
      queue.perform_actions
      condition_effects if players.any? { |player| player.current_pokemon.health_condition != nil }
      @turn += 1
    end

    players.each do |player|
      if team_fainted?(player)
        winner = players.reject { |i| i == player }
        puts "#{winner[0].name} has won!"
      end 
    end
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
      
    print "#{player.name} select your pokemon: "
    index = gets.chomp.to_i

    return (index - 1) if index > 0 && index <= player.team.size && !player.team[index-1].fainted?
      
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

  def condition_effects
    players.each do |player|
      pok = player.current_pokemon
      if !pok.fainted?
        pok.health_condition&.dmg_effect(pok)
        pok.health_condition&.turn_count if !pok.health_condition&.turn.nil?
        puts "#{pok.name} has fanited" if pok.fainted?
      end
    end
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

puts PokemonBattleField.init_game(2, pokemons)