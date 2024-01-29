require_relative "messages_pool"
require_relative "actions/menu"

class Trainer
  attr_accessor :name, :team, :current_pokemon, :action, :opponents, :data, :battlefield

  def initialize(name:)
    @name = name
    @team = []
    @current_pokemon = nil
    @action = nil
    @opponents = nil
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
    MessagesPool.pokemon_selection(name)
    @team.clear
    @opponents = players.reject { |player| player == self }
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

  def select_action
    @action = Menu.select_action(self)
  end

  def view_pokemons
    team.each.with_index(1) do |pok, index|
      next if pok == current_pokemon
      puts "#{index}- #{pok.to_s}" if !pok.fainted?
    end
  end
  
  def select_pokemon(index, source)
    next_pokemon = team[index]

    if source == :baton_pass
      baton_pass_stats(next_pokemon)
      baton_pass_volatile_status(next_pokemon)
    end

    current_pokemon.stats.each do |stat|
      stat.reset_stat
    end
    current_pokemon.reinit_all_metadata
    current_pokemon.reinit_volatile_condition

    SwitchAction.new(
      speed: current_pokemon.actual_speed,
      behaviour: next_pokemon,
      trainer: self
    )
  end

  def baton_pass_stats(next_pokemon)
    stages = []
    current_pokemon.stats.each do |stat|
      stages << stat.stage unless stat.hp?
    end
    next_pokemon.stats.each do |stat|
      stat.stage = stages.shift unless stat.hp?
    end

    next_pokemon.stats.each { |stat| stat.in_game_stat_calc }
    next_pokemon.metadata[:crit_stage] = current_pokemon.metadata[:crit_stage]
  end

  def baton_pass_volatile_status(next_pokemon)
    status = current_pokemon.volatile_status
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