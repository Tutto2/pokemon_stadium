require 'json'
require_relative 'data_manager'
require_relative "../messenger/messages_pool"
# require_relative "menu"

class Trainer
  attr_accessor :name, :team, :action, :teammate, :data, :battleground

  def initialize(name:)
    @name = name
    @team = []
    @action = []
    @teammate = nil
    @battleground = nil
    @data = {}
  end

  def self.select_name(index, players_num, battle_type)
    battle_type == 'double' && players_num == 4 ? MessagesPool.select_teammate_name(index) : MessagesPool.select_player_name(index)
    name = gets.chomp

    return Trainer.new(name: name) if !name.empty? && name.length < 10
    MessagesPool.invalid_name_input

    select_name(index, players_num, battle_type)
  end

  def team_selection(pokemons, players_num)
    MessagesPool.menu_leap
    @team.clear
    MessagesPool.team_selection_index
    index_selection = 0
    
    loop do
      MessagesPool.action_selection(name)
      index_selection = gets.chomp.to_i

      break if [1, 2].include?(index_selection)
      MessagesPool.invalid_option
    end

    index_selection == 1 ? pre_set_team_index(pokemons, players_num) : build_team(pokemons, players_num)
  end

  def assing_player_team(index, players, battleground)
    @battleground = battleground

    if battleground.battle_type == 'double' && players.size == 4
      teammate_mapping = {
        0 => 1,
        1 => 0,
        2 => 3,
        3 => 2
      }

      @teammate = players[teammate_mapping[index]]
    end
  end
  
  def view_pokemons
    team.each.with_index(1) do |pok, index|
      next if battleground.field.positions.values.include?(pok)
      BattleLog.instance.log(MessagesPool.poke_index(pok, index)) if !pok.fainted?
    end
    BattleLog.instance.display_messages
  end
  
  def select_action(user_pok)
    selected_action = Menu.select_action(self, user_pok)
    @battleground.action_list[user_pok.name] = selected_action
    @action << selected_action
  end

  def select_pokemon(user_pokemon, index, source)
    next_pokemon = team[index]
    position = user_pokemon.field_position
    next_pokemon.field_position = position

    if source == :baton_pass
      baton_pass_stats(user_pokemon, next_pokemon)
      baton_pass_volatile_status(user_pokemon, next_pokemon)
    end

    user_pokemon.got_out_of_battle

    SwitchAction.new(
      speed: user_pokemon.actual_speed,
      behaviour: next_pokemon,
      trainer: self,
      user_pokemon: user_pokemon
    )
  end

  def baton_pass_stats(user_pokemon, next_pokemon)
    stages = []
    user_pokemon.stats.each do |stat|
      stages << stat.stage unless stat.hp?
    end
    next_pokemon.stats.each do |stat|
      stat.stage = stages.shift unless stat.hp?
    end

    next_pokemon.stats.each { |stat| stat.in_game_stat_calc }
    next_pokemon.metadata[:crit_stage] = user_pokemon.metadata[:crit_stage]
  end

  def baton_pass_volatile_status(user_pokemon, next_pokemon)
    status = user_pokemon.volatile_status
    return if status.empty?

    it_passes = %i[
      confused
      substitute
      cursed
      seeded
    ]
    status.keep_if { |name, status| it_passes.include?(name) }

    next_pokemon.volatile_status = status
  end

  def keep_action(action, turns)
    return unless data[:pending_action].nil?
    @data[:pending_action] = action
    @data[:remaining_turns] = turns
  end

  def regressive_count
    if data[:remaining_turns] <= 0
      @data.delete(:remaining_turns)
      @data.delete(:pending_action)
      return
    end

    @data[:remaining_turns] -= 1
    act = data[:pending_action]
    BattleLog.instance.log(MessagesPool.remaining_turns_msg(data[:remaining_turns], act.behaviour.attack_name))
  end

  def pending_action
    data[:pending_action]
  end

  def team_fainted?
    team.all?(&:fainted?)
  end

  def ==(other)
    name == other.name
  end

  private

  def pre_set_team_index(pokemons, players_num)
    data = DataManager.view_teams_simple

    unless data.empty?
      MessagesPool.pre_set_team_index 
      index = gets.chomp

      return team_selection(pokemons, players_num) if index == 0
      return pre_set_team_index(pokemons, players_num) unless valid_selection(index.to_i)

      if index.include?("?") && detailed_team_view(index.to_i) != 'select'
        pre_set_team_index(pokemons, players_num)
      else
        puts "Im here"
        @team = DataManager.team_converter(id)
      end
    else
      MessagesPool.view_team_error
    end
  end

  def valid_selection(index)
    team = DataManager.get_team(index)

    if team.empty?
      MessagesPool.invalid_option
      false
    else
      true
    end
  end

  def detailed_team_view(index)
    DataManager.view_team_detailed(index)
    MessagesPool.select_detailed_team
    gets.chomp.downcase
  end

  def build_team(pokemons, players_num)
    view_all_pokes(pokemons)
    MessagesPool.pokemon_selection(name)
    selection = gets.chomp.split.map(&:to_i)

    if team_verification(selection, pokemons, players_num)
      @team = selection.map { |pick| pokemons[pick-1] }
      @team.each { |pok| pok.trainer = self }
    else
      MessagesPool.invalid_pokemon_selection
      return team_selection(pokemons, players_num)
    end
  end

  def view_all_pokes(pokemons)
    pokemons.each.with_index(1) do |pok, index|
      BattleLog.instance.log(MessagesPool.poke_index(pok, index)) if !pok.fainted?
    end
    BattleLog.instance.display_messages
  end

  def team_verification(selection, pokemons, players_num)
    selection.all? { |pick| (1..pokemons.size).include?(pick) } && (( players_num == 2 && (1..6).include?(selection.size)) || (players_num > 2 && (1..3).include?(selection.size)))
  end
end