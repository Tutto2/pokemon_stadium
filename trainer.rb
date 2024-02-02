require_relative "messages_pool"
require_relative "actions/menu"

class Trainer
  attr_accessor :name, :team, :current_pokemons, :action, :opponents, :data, :battlefield

  def initialize(name:)
    @name = name
    @team = []
    @current_pokemons = []
    @action = []
    @opponents = []
    @battlefield = nil
    @data = {}
  end

  def self.select_name(index)
    MessagesPool.select_player_name(index)
    name = gets.chomp

    return Trainer.new(name: name) if !name.empty? && name.length < 10
    MessagesPool.invalid_name_input
    select_name(index)
  end

  def team_build(pokemons, players, battlefield)
    puts
    @team.clear
    @opponents = players.reject { |player| player == self }
    MessagesPool.pokemon_selection(name)
    selection = gets.chomp.split.map(&:to_i)

    if selection.all? { |pick| (1..pokemons.size).include?(pick) } && (1..6).include?(selection.size)
      @team = selection.map { |pick| pokemons[pick-1] }
      @team.each { |pok| pok.trainer = self }
      @battlefield = battlefield
    else
      MessagesPool.invalid_pokemon_selection
      return team_build(pokemons, players, battlefield)
    end
  end

  def select_action(user_pok)
    @action << Menu.select_action(self, user_pok)
  end

  def view_pokemons
    team.each.with_index(1) do |pok, index|
      next if current_pokemons.include?(pok)
      puts "#{index}- #{pok.to_s}" if !pok.fainted?
    end
  end
  
  def select_pokemon(user_pokemon, index, source)
    next_pokemon = team[index]

    if source == :baton_pass
      baton_pass_stats(user_pokemon, next_pokemon)
      baton_pass_volatile_status(user_pokemon, next_pokemon)
    end

    user_pokemon.stats.each do |stat|
      stat.reset_stat
    end
    user_pokemon.reinit_all_metadata
    user_pokemon.reinit_volatile_condition

    SwitchAction.new(
      speed: user_pokemon.actual_speed,
      behaviour: next_pokemon,
      trainer: self,
      user_pokemon: user_pokemon
    )
  end

  def only_one_poke_remaining_on_doubles
    pok = current_pokemons.find { |pok| pok.fainted? }

    @current_pokemons.each.with_index do |position, index|
      if position == pok
        current_pokemons.delete_at(index)
      end
    end
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
    puts "Turns remaining #{data[:remaining_turns]} for #{data[:pending_action].behaviour.attack_name} to execute"
  end

  def pending_action
    data[:pending_action]
  end

  def ==(other)
    name == other.name
  end
end