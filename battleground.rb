require_relative "messages_pool"
require_relative "battle_log"
require_relative "trainer"
require_relative "actions/menu"
require_relative "actions/action_queue"
require_relative "pokedex/pokedex"
require "pry"
# binding.pry

class PokemonBattleField
  attr_accessor :attack_list #:field_positions
  attr_reader :players, :battle_type, :all_pokes, :turn, :battle_type

  def self.init_game(players_num, battle_type, pokemons)
    players = select_players_names(players_num)

    battlefield = PokemonBattleField.new(
      players: players,
      battle_type: battle_type,
      all_pokes: pokemons
    )

    battlefield.choose_pokemons
  end

  def self.select_players_names(players_num)
    (1..players_num).map do |index|
      Trainer.select_name(index.to_s)
    end
  end

  def initialize(players: [], battle_type:, all_pokes: [], attack_list: [])
    @players = players
    @battle_type = battle_type
    # @field_positions = field_positions
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
    # assing_initial_position
    puts
    loop do
      break if players.any? { |player| team_fainted?(player) }
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

      display_pokemons
      players.each do |player|
        player.current_pokemons.each { |pok| pok.trainer.select_action(pok) }
      end

      queue = ActionQueue.new
      players.each do |player|
        player.action.each do |action|
          queue << action
        end
        queue << player.pending_action if action_count_complete?(player)
      end
      queue.perform_actions
      reinit_protections_and_harm
      players.each { |player| player.regressive_count unless player.data[:remaining_turns].nil? }
      condition_effects if players.any? { |player| player.current_pokemons.any? { |pok| pok.health_condition != nil }}
      status_effects
      BattleLog.instance.display_messages
      @turn += 1
    end

    declare_winner
  end

  private

  def clear_actions(player)
    player.action = []
  end

  # def assing_initial_position
  #   if players.size == 2 && battle_type == 'double'
  #     index = 1
  #     players.each do |player|
  #       player.current_pokemons.each.with_index do |pok, i|
  #         field_positions[index] = player.current_pokemons[i]
  #         index += 1
  #       end
  #     end
  #   else
  #     players.each.with_index(1) do |player, index|
  #       field_positions[index] = player.current_pokemons[0]
  #     end
  #   end
  # end

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
    MessagesPool.select_pokemon(player.name, battle_type)
    index = gets.chomp.split.map(&:to_i)

    return index if valid_index?(player, index)

    battle_type == 'single' ? MessagesPool.invalid_option : MessagesPool.invalid_option_on_doubles
    return select_initial_index(player)
  end

  def valid_index?(player, index)
    case battle_type
    when 'single'
      index.size == 1 && (1..player.team.size).include?(index[0])
    when 'double'
      index.size == 2 && index.all? { |pick| (1..player.team.size).include?(pick) } && index[0] != index[1]
    end
  end

  def team_fainted?(player)
    player.team.all?(&:fainted?)
  end

  def display_pokemons
    players.each do |player|
      MessagesPool.player_current_pokemons(player.name, battle_type)
      player.current_pokemons.each { |pok| pok.status }
    end
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
    players.each do |player|
      next if team_fainted?(player)
      MessagesPool.declare_winner(player.name)
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

puts PokemonBattleField.init_game(2, 'double', pokemons)