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
  attr_reader :players, :battle_type, :all_pokes, :turn, :battle_type

  def self.init_game(players_num, battle_type, pokemons)
    return MessagesPool.invalid_game_settings(players_num, battle_type) if !(2..4).include?(players_num.size) || battle_type == 'double' && players_num == 3
    players = select_players_names(players_num)

    battlefield = PokemonBattleField.new(
      players: players,
      battle_type: battle_type,
      all_pokes: pokemons
    )

    battlefield.choose_pokemons
  end

  def self.select_players_names(players_num, battle_type)
    (1..players_num).map do |index|
      Trainer.select_name(index, players_num, battle_type)
    end
  end

  def initialize(players: [], battle_type:, all_pokes: [], attack_list: [])
    @players = players
    @battle_type = battle_type
    @all_pokes = all_pokes
    @attack_list = attack_list
  end


  def choose_pokemons
    view_pokemons(all_pokes)
    players.each.with_index do |player, index|
      player.team_build(all_pokes)
      player.assing_player_team(index, players, self)
    end
    start_battle
  end

  def start_battle
    @turn = 1
    select_initial_pok(players)
    puts
    loop do
      break if game_over?
      init_turn_actions
      display_pokemons

      players.each do |player|
        player.current_pokemons.each { |pok| pok.trainer.select_action(pok) }
      end

      queue = ActionQueue.new
      enqeue_actions(queue)
      queue.perform_actions
      
      end_turn_actions
    end

    declare_winner
  end

  private
  
  def view_pokemons(pokemons)
    pokemons.each.with_index(1) do |pok, index|
      puts "#{index}- #{pok.to_s}" if !pok.fainted?
    end
  end
  
  def select_initial_pok(players)
    players.each do |player|
      view_pokemons(player.team)
      index = select_initial_index(player)
      selection = []

      index.size.times do
        selection << player.team[index.shift - 1]
      end

      selection.size.times do
        player.current_pokemons << selection.shift
      end
    end
  end

  def select_initial_index(player)
    MessagesPool.select_pokemon(player.name, battle_type, players)
    index = gets.chomp.split.map(&:to_i)

    return index if valid_index?(player, index)

    battle_type == 'double' && players.size == 2 ? MessagesPool.invalid_option_on_doubles : MessagesPool.invalid_option
    return select_initial_index(player)
  end

  def valid_index?(player, index)
    if battle_type == 'double' && players.size == 2
      index.size == 2 && index.all? { |pick| (1..player.team.size).include?(pick) } && index[0] != index[1]
    else
      index.size == 1 && (1..player.team.size).include?(index[0])
    end
  end

  def game_over?
    players.any? { |player| player.opponents.all?(&:team_fainted?) }
  end

  def team_fainted?(player)
    player.team.all?(&:fainted?)
  end    

  def init_turn_actions
    MessagesPool.turn(turn)
    players.each { |player| clear_actions(player) }
    players.each do |player| 
      if player.current_pokemons.any?(&:fainted?)
        if player.team.count { |pok| !pok.fainted? } == 1 && battle_type == 'double'
          player.only_one_poke_remaining_on_doubles
        else
          Menu.pokemon_selection_index(player, player.current_pokemons.find { |pok| pok.fainted? }).perform
        end    
      end    
    end    
  end    
  
  def clear_actions(player)
    player.action = []
  end    

  def display_pokemons
    players.each do |player|
      MessagesPool.player_current_pokemons(player.name, battle_type)
      player.current_pokemons.each { |pok| pok.status }
    end
  end

  def enqeue_actions(queue)
    players.each do |player|
      player.action.each do |action|
        queue << action
      end

      queue << player.pending_action if action_count_complete?(player)
    end
  end

  def action_count_complete?(trainer)
    trainer.data[:remaining_turns] == 0
  end

  def end_turn_actions
    reinit_protections_and_harm

    players.each { |player| player.regressive_count unless player.data[:remaining_turns].nil? }
    condition_effects
    status_effects

    BattleLog.instance.display_messages
    @turn += 1
  end
  
  def reinit_protections_and_harm
    players.each do |player|
      player.current_pokemons.each do |pok|
        pok.protection_delete if pok.is_protected?
        pok.reinit_endure if pok.will_survive
        pok.harm_reinit
      end
    end
  end

  def condition_effects
    players.each do |player|
      player.current_pokemons.each do |pok|
        next if pok.fainted? || pok.health_condition.nil?
    
        condition = pok.health_condition
        condition&.dmg_effect(pok)
        condition&.turn_count if !condition&.turn.nil?
        BattleLog.instance.log(MessagesPool.pok_fainted_msg(pok.name)) if pok.fainted? && !condition.dmg_effect(pok).nil?
      end
    end
  end

  def status_effects
    players.each do |player|
      player.current_pokemons.each do |pok|
        next if pok.fainted? || pok.volatile_status.empty?

        pok.volatile_status.each do |name, status|
          status&.dmg_effect(pok)
          status.turn_count
          status.perish_song_effect(pok) if name == :perish_song && status.turn == 4
        end
      end
    end
  end

  def declare_winner
    winners = []
    players.each do |player|
      winners << player if player.opponents.all?(&:team_fainted?)      
    end

    winners.size == 1 ? MessagesPool.declare_winner(winners[0].name) : MessagesPool.declare_two_winners(winners)
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

puts PokemonBattleField.init_game(2, 'double', pokemons)