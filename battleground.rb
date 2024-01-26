require_relative "messages_pool"
require_relative "battle_log"
require_relative "trainer"
require_relative "actions/menu"
require_relative "actions/action_queue"
require_relative "pokedex/pokedex"
require "pry"
# binding.pry

class PokemonBattleField
  attr_accessor :attack_list
  attr_reader :players, :all_pokes, :turn

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

  def initialize(players: [], all_pokes: [], attack_list: [])
    @players = players
    @all_pokes = all_pokes
    @attack_list = attack_list
  end

  def choose_pokemons
    view_pokemons(all_pokes)
    players.each do |player|
      player.team_build(all_pokes, players, self)
    end
    start_battle
  end

  def start_battle
    @turn = 1
    select_initial_pok(players)

    loop do
      break if players.any? { |player| team_fainted?(player) }
      MessagesPool.turn(turn)
      players.each do |player| 
        if player.current_pokemon.fainted?
          player.current_pokemon = player.team[selection_index(player)]
          puts
        end
      end

      display_pokemons
      players.each { |player| player.select_action }

      queue = ActionQueue.new
      players.each do |player|
        queue << player.action
        queue << player.pending_action if action_count_complete?(player)
      end

      queue.perform_actions
      reinit_protections_and_harm
      players.each { |player| player.regressive_count unless player.data[:remaining_turns].nil? }
      condition_effects if players.any? { |player| player.current_pokemon.health_condition != nil }
      status_effects
      BattleLog.instance.display_messages
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

  def action_count_complete?(trainer)
    trainer.data[:remaining_turns] == 0
  end

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
    
    MessagesPool.select_pokemon(player.name)
    index = gets.chomp.to_i

    return (index - 1) if index > 0 && index <= player.team.size && !player.team[index-1].fainted?
      
    MessagesPool.invalid_option
    return selection_index(player)
  end

  def team_fainted?(player)
    player.team.all?(&:fainted?)
  end

  def display_pokemons
    players.each do |player|
      MessagesPool.player_current_pokemon(player.name)
      player.current_pokemon.status
    end
  end

  def reinit_protections_and_harm
    players.each do |player|
      pok = player.current_pokemon
      pok.protection_delete if pok.is_protected?
      pok.reinit_endure if pok.will_survive
      pok.harm_reinit
    end
  end

  def condition_effects
    players.each do |player|
      pok = player.current_pokemon
  
      next if pok.fainted? || pok.health_condition.nil?
  
      condition = pok.health_condition
      condition&.dmg_effect(pok)
      condition&.turn_count if !condition&.turn.nil?
      puts "#{pok.name} has fainted" if pok.fainted?
    end
  end

  def status_effects
    players.each do |player|
      pok = player.current_pokemon

      next if pok.fainted? || pok.volatile_status.empty?

      pok.volatile_status.each do |name, status|
        status&.dmg_effect(pok)
        status.turn_count
        status.perish_song_effect(pok) if name == :perish_song && status.turn == 4
      end
    end
  end
end

pokemons = [
  Pokedex.catch("Squirtle"),
  Pokedex.catch("Pikachu"),
  Pokedex.catch("Jigglypuff"),
  Pokedex.catch("Golem"),
  Pokedex.catch("Snorlax"),
  Pokedex.catch("Gengar"),
  Pokedex.catch("Ditto"),
  Pokedex.catch("Mew"),
  Pokedex.catch("Sceptile"),
  Pokedex.catch("Milotic"),
  Pokedex.catch("Kommo-o"),
  Pokedex.catch("Dragapult"),
  Pokedex.catch("Baxcalibur"),
  Pokedex.catch("Ogerpon (Fire)"),
  Pokedex.catch("Tinkaton"),
  Pokedex.catch("Ceruledge"),
  Pokedex.catch("Poltchageist"),
  Pokedex.catch("Gholdengo"),
  Pokedex.catch("Zoroark-hisui"),
  Pokedex.catch("Dracanfly")
  # Pokedex.catch("Dracanfly")
]

puts PokemonBattleField.init_game(2, pokemons)