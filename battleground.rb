require_relative "messages_pool"
require_relative "battle_log"
require_relative "trainer"
require_relative "field"
require_relative "actions/menu"
require_relative "actions/action_queue"
require_relative "pokedex/pokedex"
require "httparty"
require "pry"

binding.pry
# require "rim_job"

class PokemonBattleField
  attr_accessor :action_list, :attack_list
  attr_reader :players, :battle_type, :all_pokes, :turn, :battle_type, :field

  def self.init_game(players_num, battle_type, pokemons)
    return MessagesPool.invalid_game_settings(players_num, battle_type) unless game_settings_verification(players_num, battle_type)
    players = select_players_names(players_num, battle_type)

    battlefield = PokemonBattleField.new(
      players: players,
      battle_type: battle_type,
      all_pokes: pokemons
    )

    battlefield.choose_pokemons
  end

  def self.game_settings_verification(players_num, battle_type)
    case players_num
    when 2
      battle_type == 'single' || battle_type == 'double'
    when 3, 4
      battle_type == 'royale' || battle_type == 'double'
    else
      false
    end
  end

  def self.select_players_names(players_num, battle_type)
    (1..players_num).map do |index|
      Trainer.select_name(index, players_num, battle_type)
    end
  end

  def initialize(players:, battle_type:, all_pokes:, action_list: {}, attack_list: {})
    @players = players
    @battle_type = battle_type
    @all_pokes = all_pokes
    @action_list = action_list
    @attack_list = attack_list
    @field = Field.new
  end


  def choose_pokemons
    view_pokemons(all_pokes)
    players.each.with_index do |player, index|
      player.team_build(all_pokes, players.size)
      player.assing_player_team(index, players, self)
    end
    start_battle
  end

  def start_battle
    @turn = 1
    select_initial_pok
    MessagesPool.menu_leap
    loop do
      break if game_over?
      init_turn_actions
      display_pokemons

      field.positions.each { |_, pok| pok.trainer.select_action(pok) }
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
      BattleLog.instance.log(MessagesPool.poke_index(pok, index)) if !pok.fainted?
    end
    BattleLog.instance.display_messages
  end
  
  def select_initial_pok
    players.each.with_index(1) do |player, index|
      view_pokemons(player.team)
      index_selection = select_initial_index(player)
      pok_selection = []

      index_selection.size.times do
        pok_selection << player.team[index_selection.shift - 1]
      end

      assing_position(pok_selection, index)
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

  def assing_position(pok_selection, index)
    if battle_type == 'double' && players.size == 2
      pok_selection.each_with_index do |pok, i|
        field_position = index + (i * 2)
        pok.field_position = field_position
        field.positions[field_position] = pok
      end
    elsif battle_type == 'double' && players.size == 4
      pok = pok_selection.shift
      case index
      when 2
        field.positions[3] = pok
        pok.field_position = 3
      when 3
        field.positions[2] = pok
        pok.field_position = 2
      else
        field.positions[index] = pok
        pok.field_position = index
      end
    else
      pok = pok_selection.shift
      field.positions[index] = pok
      pok.field_position = index
    end
  end

  def game_over?
    if battle_type == 'double' && players.size == 4
      players.any? { |player| team_fainted?(player) && team_fainted?(player.teammate) }
    elsif players.size > 2
      players.count { |player| team_fainted?(player) } == players.size - 1
    else
      players.any? { |player| team_fainted?(player) }
    end
  end

  def team_fainted?(player)
    player.team.all?(&:fainted?)
  end    

  def init_turn_actions
    MessagesPool.turn(turn)
    players.each { |player| clear_actions(player) }
    
    until !field.any_pokemon_fainted?
      change_fainted_pokemon
    end

    BattleLog.instance.display_messages 
  end    
  
  def clear_actions(player)
    player.action = []
  end

  def change_fainted_pokemon
    fainted_pok = field.positions.find { |i, pok| pok.fainted? }
    index = fainted_pok[0]
    pok = fainted_pok[1]
    trainer = pok.trainer

    if (battle_type == 'double' && players.size == 2 && last_pok_remainig?(trainer)) || team_fainted?(trainer)
      field.positions.delete(index)
    else
      Menu.pokemon_selection_index(trainer, pok, source: :turn_init).perform
    end
  end

  def last_pok_remainig?(player)
    if player.team.count { |pok| !pok.fainted? } == 1
      last_pok = player.team.find { |pok| !pok.fainted? }
      last_pok.field_position != nil
    else
      false
    end
  end

  def display_pokemons
    if battle_type == 'double'
      MessagesPool.first_team_msg
      field.positions.each do |i, pok|
        next if i.even?
        pok.status
      end
      
      MessagesPool.second_team_msg
      field.positions.each do |i, pok|
        next if i.odd?
        pok.status
      end
    else
      field.positions.each do |i, pok|
        MessagesPool.trainer_name(pok)
        pok.status
      end
    end
  end

  def enqeue_actions(queue)
    players.each do |player|
      player.action.compact.each do |action|
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
    field.positions.each do |_, pok|
      pok.protection_delete if pok.is_protected?
      pok.reinit_endure if pok.will_survive
      pok.harm_reinit
    end
  end

  def condition_effects
    field.positions.each do |_, pok|
      next if pok.fainted? || pok.health_condition.nil?
  
      condition = pok.health_condition
      condition&.dmg_effect(pok)
      condition&.turn_count if !condition&.turn.nil?
      BattleLog.instance.log(MessagesPool.pok_fainted_msg(pok.name)) if pok.fainted? && !condition.dmg_effect(pok).nil?
    end
  end

  def status_effects
    field.positions.each do |_, pok|
      next if pok.fainted? || pok.volatile_status.empty?

      pok.volatile_status.each do |name, status|
        next if pok.fainted?
        status&.dmg_effect(pok)
        status.turn_count
        status.perish_song_effect(pok) if name == :perish_song && status.turn == 4
        BattleLog.instance.log(MessagesPool.pok_fainted_msg(pok.name)) if pok.fainted? && !status.dmg_effect(pok).nil?
      end
    end
  end

  def declare_winner
    winners = []
    players.each do |player|
      if players.size == 4 && battle_type == 'double'
        winners << player if !team_fainted?(player) || !team_fainted?(player.teammate)
      else
        winners << player if !team_fainted?(player)
      end
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
]

puts PokemonBattleField.init_game(4, 'double', pokemons)