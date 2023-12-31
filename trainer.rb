require_relative "actions/menu"

class Trainer
  attr_accessor :name, :team, :current_pokemon, :action, :opponents

  def initialize(name:)
    @name = name
    @team = []
    @current_pokemon = nil
    @action = nil
    @opponents = nil
  end

  def self.select_name(index)
    print "Player #{index}, select your name: "
    name = gets.chomp

    return Trainer.new(name: name) if !name.empty? && name.length < 10
    puts "Invalid input, the name must be less than 10 characters"
    select_name(index)
  end

  def team_build(pokemons, players)
    print "#{name} select a set of pokemon to battle: "
    @team.clear
    @opponents = players.reject { |player| player == self }
    selection = gets.chomp.split.map(&:to_i)

    if selection.all? { |pick| (1..pokemons.size).include?(pick) } && (1..6).include?(selection.size)
      @team = selection.map { |pick| pokemons[pick-1] }
      @team.each { |pok| pok.trainer = self }
    else
      puts "Pick 1 to 6 pokemons, and provide valid indices. Try again."
      return team_build(pokemons, players)
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

    next_pokemon.stats.each { |stat| stat.baton_calc }
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

  def ==(other)
    name == other.name
  end
end