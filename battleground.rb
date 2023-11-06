require_relative "pokedex/pokedex"

class PokemonBattleField
  SWITCH_ACTION = 0.freeze
  ATK_ACTION = 5.freeze

  attr_reader :all_pokes, :pokemons_p1, :pokemons_p2, :action_p1, :action_p2

  def initialize(all_pokes: [], pokemons_p1: [], pokemons_p2: [], action_p1: nil, action_p2: nil)
    @all_pokes = all_pokes
    @pokemons_p1 = pokemons_p1
    @pokemons_p2 = pokemons_p2
    @action_p1 = action_p1
    @action_p2 = action_p2
  end

  def choose_pokemons
    view_pokemons(@all_pokes)
    team_build(:one)
    team_build(:two)
    start_battle
  end

  def start_battle
    $turn = 1
    @current_pokemon_p1 = pokemons_p1[selection_index(:one, pokemons_p1.length)]
    @current_pokemon_p2 = pokemons_p2[selection_index(:two, pokemons_p2.length)]

    loop do
      break if pokemons_p1.all?(&:fainted?) || pokemons_p2.all?(&:fainted?)
      puts
      puts "############ turn #{$turn} ############"
      @current_pokemon_p1 = pokemons_p1[selection_index(:one, pokemons_p1.length)] if @current_pokemon_p1.fainted?
      @current_pokemon_p2 = pokemons_p2[selection_index(:two, pokemons_p2.length)] if @current_pokemon_p2.fainted?

      display_pokemon(@current_pokemon_p1, :one)
      display_pokemon(@current_pokemon_p2, :two)

      @action_p1 = select_action(:one, @current_pokemon_p1, pokemons_p1)
      @action_p2 = select_action(:two, @current_pokemon_p2, pokemons_p2)

      switch_actions, attack_actions = [@action_p1, @action_p2].partition { |action| action[:action] == SWITCH_ACTION }
      actions = attack_actions.sort(&priority_queue)

      switch_actions.each(&perform)
      actions.each(&perform)
      $turn += 1
    end

    return 'Player two wins!' if pokemons_p1.all?(&:fainted?)
    return 'Player one Wins!' if pokemons_p2.all?(&:fainted?)
  end

  private

  attr_reader :pokemons_p1, :pokemons_p2

  def view_pokemons(pokemons)
    pokemons.each.with_index(1) do |pok, index|
      puts "#{index}- #{pok.to_s}" if !pok.fainted?
    end
  end

  def team_build(player)
    print "Player #{player} select a set of pokemon to battle: "
    selection = gets.chomp.split
    selection = selection.map { |x| x.to_i }

    if !selection.empty? && (1..6).include?(selection.size)
      selection.each do |pick|
        if (1..(all_pokes.size)).include?(pick) 
          case player
          when :one then pokemons_p1.push(@all_pokes[pick-1])
          when :two then pokemons_p2.push(@all_pokes[pick-1])
          end
        else 
          puts "Write the index (1 - #{all_pokes.size}) of each pokemon you want"
          return team_build(player)
        end
      end
    else
      puts "Pick 1 to 6 pokemons, try again"
      team_build(player)
    end
  end

  def selection_index(player, limit)
    pokemons = player == :one ? pokemons_p1 : pokemons_p2
    view_pokemons(pokemons)
    go_back(pokemons) if limit == (pokemons.length) + 1
      
    print "Player #{player} select your pokemon: "
    index = gets.chomp.to_i

    return (index - 1) if index > 0 && index <= limit
      
    puts "Invalid option. Try again"
    return selection_index(player, limit)
  end

  def display_pokemon(pokemon, player)
    puts "Player #{player} pokemon:"
    puts pokemon.status
  end

  def select_action(player, current_pokemon, pokemons)
    action_num = action_index(player)
    
    case action_num
    when 1
      if current_pokemon.is_attacking?
        player == :one ? action_p1 : action_p2
      else
        current_pokemon.view_attacks
        go_back(current_pokemon.attacks)
        attk_num = select_attack

        if (1..4).include?(attk_num)
          {
            action: ATK_ACTION,
            attk_num: attk_num,
            player: player
          }
        else
          return select_action(player, current_pokemon, pokemons)
        end
      end
    when 2
      next_pokemon = switch_pokemon(player, current_pokemon, pokemons)
      return select_action(player, current_pokemon, pokemons) if next_pokemon.nil?
      
      {
        action: SWITCH_ACTION,
        player: player,
        next_pokemon: next_pokemon
      }
    end
  end

  def action_index(player)
    puts "1- Attack"
    puts "2- Change pokemon"
    print "Player #{player}, what do you want to do?: "
    num = gets.chomp.to_i

    return num if num == 1 || num == 2

    puts "Not a valid option. Try again"
    action_index(player)
  end

  def select_attack
    print 'Enter the attack number: '
    attk_num = gets.chomp.to_i

    return attk_num if (1..5).include?(attk_num)

    puts "Not a valid option, try again."
    select_attack
  end

  def switch_pokemon(player, current_pokemon, pokemons)
    next_pokemon = pokemons[selection_index(player, pokemons.length + 1)]

    return next_pokemon if next_pokemon.nil?

    if current_pokemon == next_pokemon
      puts "That's your current pokemon, pick another one."
      return switch_pokemon(player, current_pokemon, pokemons)
    elsif next_pokemon.fainted?
      puts "#{next_pokemon} it's fainted, pick another one."
      return switch_pokemon(player, current_pokemon, pokemons)
    end

    current_pokemon.stats.each do |stat|
      stat.reset_stat
    end
    current_pokemon.ending_several_turn_attack
    next_pokemon
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

  def perform_action(action_message)
    if action_message[:action] == SWITCH_ACTION
      perform_switch(action_message)
    elsif action_message[:action] == ATK_ACTION
      perform_attack(action_message)
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
battlefield = PokemonBattleField.new(all_pokes: pokemons)
puts battlefield.choose_pokemons