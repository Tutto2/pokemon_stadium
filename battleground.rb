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
        perform_action(action)
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

  def select_action(player, current_pokemon)
    case player
    when :one 
      previous_atk = action_p1.nil? ? 0 : action_p1[:attk_num]
      pokemons = pokemons_p1
    when :two
      previous_atk = action_p2.nil? ? 0 : action_p2[:attk_num]
      pokemons = pokemons_p2
    end
    action_num = action_index(player)

    case action_num
    when 1
      attack_act(player, current_pokemon, previous_atk)
    when 2
      switch_act(player, current_pokemon, pokemons)
    end
  end

  def action_index(player)
    puts "1- Attack"
    puts "2- Change pokemon"
    print "Player #{player}, what do you want to do?: "
    num = gets.chomp.to_i

    return num if num == 1 || num == 2

    puts "Not a valid option. Try again"
    return action_index(player)
  end

  def attack_act(player, current_pokemon, previous_atk)
    if current_pokemon.is_attacking?
      player == :one ? action_p1 : action_p2
    else
      current_pokemon.view_attacks
      go_back(current_pokemon.attacks)
      attk_num = select_attack(current_pokemon, previous_atk)

      if (1..4).include?(attk_num)
        {
          action: ATK_ACTION,
          attk_num: attk_num,
          player: player
        }
      else
        return select_action(player, current_pokemon)
      end
    end
  end

  def select_attack(current_pokemon, previous_atk)
    print 'Enter the attack number: '
    attk_num = gets.chomp.to_i

    if current_pokemon.has_banned_attack? && attk_num == previous_atk
      puts "This move can't be used twice in a row"
      return select_attack(current_pokemon, previous_atk)
    end

    return attk_num if (1..5).include?(attk_num)

    puts "Not a valid option, try again."
    return select_attack(current_pokemon, previous_atk)
  end

  def switch_act(player, current_pokemon, pokemons)
    next_pokemon = switch_pokemon(player, current_pokemon, pokemons)
        
    {
      action: SWITCH_ACTION,
      player: player,
      next_pokemon: next_pokemon
    }
  end

  def switch_pokemon(player, current_pokemon, pokemons)
    pokemon_index = pokemons[selection_index(player, pokemons.length + 1)]

    return select_action(player, current_pokemon) if pokemon_index.nil?

    if current_pokemon == pokemon_index
      puts "That's your current pokemon, pick another one."
      return switch_pokemon(player, current_pokemon, pokemons)
    elsif pokemon_index.fainted?
      puts "#{pokemon_index} is fainted, pick another one."
      return switch_pokemon(player, current_pokemon, pokemons)
    end

    current_pokemon.stats.each do |stat|
      stat.reset_stat
    end
    current_pokemon.reinit_metadata
    pokemon_index
  end

  def priority_queue
    lambda do |action_a, action_b|
      current_pokemon = action_a[:player] == :one ? @current_pokemon_p1 : @current_pokemon_p2
      target_pokemon = action_b[:player] == :one ? @current_pokemon_p1 : @current_pokemon_p2

      current_pokemon.atk_priority(action_a[:attk_num]) <=> target_pokemon.atk_priority(action_b[:attk_num])
    end
  end

  def perform
    ->(action) { perform_action(action) }
  end

  def perform_action(action)
    case action.action_type
    when :switch_action
      perform_switch(action)
    when :atk_action
      perform_attack(action)
    when :additional_action

    end
  end

  def perform_switch(action_message)
    next_pokemon = action_message[:next_pokemon]
    player = action_message[:player]
      
    if player == :one
      @current_pokemon_p1 = next_pokemon
    elsif player == :two
      @current_pokemon_p2 = next_pokemon
    end
  end

  def perform_attack(action_message)
    attk_num = action_message[:attk_num]
    player = action_message[:player]
      
    if player == :one
      target_pokemon = @current_pokemon_p2
      current_pokemon = @current_pokemon_p1
    elsif player == :two
      target_pokemon = @current_pokemon_p1
      current_pokemon = @current_pokemon_p2
    end

    current_pokemon.attack!(attk_num, target_pokemon) unless current_pokemon.fainted?
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