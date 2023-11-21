class Menu
  def self.select_action(trainer, previous_atk, current_pokemon)
    action_num = action_index(trainer)

    case action_num
    when 1 then attack_act(trainer, previous_atk, current_pokemon)
    when 2 then switch_act(trainer, previous_atk, current_pokemon)
    end
  end

  def self.attack_act(trainer, previous_atk, current_pokemon)
    if current_pokemon.is_attacking?
      previous_atk
    else
      current_pokemon.view_attacks
      go_back(current_pokemon.attacks)
      attk_num = select_attack(current_pokemon, previous_atk)
      
      if (1..4).include?(attk_num)
        next_attack = current_pokemon.attacks[attk_num - 1]
        Action.new(
          action_type: :atk_action, 
          priority: next_attack.priority,
          action: next_attack,
          speed: current_pokemon.spd_value
        )
      else
        return select_action(trainer, previous_atk, current_pokemon)
      end
    end
  end

  def self.switch_act(trainer, previous_atk, current_pokemon)
    next_pokemon = switch_pokemon(trainer, previous_atk, current_pokemon)
    
    Action.new(
      action_type: :switch_action,
      priority: 6,
      action: next_pokemon,
      speed: current_pokemon.spd_value
    )
  end

  def self.action_index(trainer)
    puts "1- Attack"
    puts "2- Change pokemon"
    print "#{trainer.name}, what do you want to do?: "
    num = gets.chomp.to_i

    return num if num == 1 || num == 2

    puts "Not a valid option. Try again"
    return action_index(trainer)
  end

  def self.select_attack(current_pokemon, previous_atk)
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
  
  def self.switch_pokemon(trainer, previous_atk, current_pokemon)
    new_pokemon = trainer.team[select_pokemon(trainer)]

    return select_action(trainer, previous_atk, current_pokemon) if new_pokemon.nil?

    if current_pokemon == new_pokemon
      puts "That's your current pokemon, pick another one."
      return switch_pokemon(trainer, previous_atk, current_pokemon)
    elsif new_pokemon.fainted?
      puts "#{new_pokemon.name} is fainted, pick another one."
      return switch_pokemon(trainer, previous_atk, current_pokemon)
    end

    current_pokemon.stats.each do |stat|
      stat.reset_stat
    end
    current_pokemon.reinit_metadata
    new_pokemon
  end
  
  def self.select_pokemon(trainer)
    view_pokemons(trainer.team)
    go_back(trainer.team)

    print "#{trainer.name} select your pokemon: "
    index = gets.chomp.to_i

    return (index - 1) if index > 0 && index <= ( (trainer.team.size) + 1 )

    puts "Invalid option. Try again"
    return select_pokemon(trainer)
  end

  def self.view_pokemons(pokemons)
    pokemons.each.with_index(1) do |pok, index|
      puts "#{index}- #{pok.to_s}" if !pok.fainted?
    end
  end

  def self.go_back(list)
    puts "#{ (list.length) + 1 }- Go back"
    puts
  end
end