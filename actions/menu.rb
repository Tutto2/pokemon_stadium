require_relative "action"
require_relative "attack_action"
require_relative "switch_action"
require_relative "../trainer"

class Menu
  def self.select_action(trainer)
    previous_action = trainer.action
    current_pokemon = trainer.current_pokemon
    opponents = trainer.opponents

    if current_pokemon.is_attacking?
      previous_action
    else
      action_num = action_index(trainer)
      puts
      case action_num
      when 1 then attack_select(trainer, previous_action, current_pokemon, opponents)
      when 2 then pokemon_selection_index(trainer, current_pokemon)
      end
    end
  end

  def self.action_index(trainer)
    puts "1- Attack"
    puts "2- Change pokemon"
    puts
    print "#{trainer.name}, what do you want to do with #{trainer.current_pokemon}?: "
    num = gets.chomp.to_i

    return num if num == 1 || num == 2

    puts "Not a valid option. Try again"
    return action_index(trainer)
  end

  def self.attack_select(trainer, previous_action, current_pokemon, opponents)
    return struggle_move(trainer, current_pokemon, opponents) if current_pokemon.has_no_remaining_pp?

    attk_num = select_attack_index(current_pokemon, previous_action)
    puts
    if (1..4).include?(attk_num)
      next_attack = current_pokemon.attacks[attk_num - 1]
      target = select_target(trainer, next_attack, opponents)

      if next_attack.attack_name == :baton_pass
        team = trainer.team.reject { |pok| pok == current_pokemon }

        if team.all?(&:fainted?)
          puts "Can't use that attack"
          return attack_select(trainer, previous_action, current_pokemon, opponents)
        end
      end

      return attack_act(trainer, current_pokemon, next_attack, target) unless next_attack.pp <= 0
      
      puts "#{next_attack.attack_name} has no remaining PP"
      return attack_select(trainer, previous_action, current_pokemon, opponents)
    else
      return select_action(trainer)
    end
  end

  def self.stuggle_move(trainer, current_pokemon, opponents)
    target = opponents[0]
    puts "#{current_pokemon.name} has no left moves."
    AttackAction.new(
      speed: current_pokemon.actual_speed,
      behaviour: StruggleMove.learn,
      trainer: trainer,
      target: target
    )
  end

  def self.select_target(trainer, next_attack, opponents)
    return opponents[0] unless next_attack.can_select_target?

    pick_a_target(trainer, opponents)
  end

  def self.pick_a_target(trainer, opponents)
    allies = [trainer]
    all_targets = allies + opponents
    
    show_posible_targets(allies, (allies.size + 1), opponents)

    print "Select a target: "
    index = gets.chomp.to_i

    if index > 0 && index <= all_targets.size
      all_targets[index - 1]
    else
      return pick_a_target(trainer, opponents)
    end
  end

  def self.show_posible_targets(allies, count, opponents)
    puts "Allies: "
    allies.each.with_index(1) do |ally, index|
      puts "#{index}- #{ally.current_pokemon.to_s}"
    end
    puts
    puts "Opponents: "
    opponents.each.with_index(count) do |opp, index|
      puts "#{index}- #{opp.current_pokemon.to_s}"
    end
  end

  def self.select_attack_index(current_pokemon, previous_action)
    current_pokemon.view_attacks
    go_back(current_pokemon.attacks)
    print 'Enter the attack number: '
    attk_num = gets.chomp.to_i

    if current_pokemon.has_banned_attack? && current_pokemon.attacks[attk_num - 1] == previous_action.behaviour
      puts "This move can't be used twice in a row"
      return select_attack_index(current_pokemon, previous_action)
    end

    return attk_num if (1..5).include?(attk_num)

    puts "Not a valid option, try again."
    return select_attack_index(current_pokemon, previous_action)
  end

  def self.attack_act(trainer, current_pokemon, next_attack, target)
    AttackAction.new(
      speed: current_pokemon.actual_speed,
      behaviour: next_attack,
      trainer: trainer,
      target: target
    )
  end
  
  def self.pokemon_selection_index(trainer, current_pokemon, source: nil)
    trainer.view_pokemons
    go_back(trainer.team) if source.nil?
    
    index = select_pokemon(trainer, current_pokemon)
    size = trainer.team.size

    if source.nil? && index == size
      return select_action(trainer)
    elsif index == size
      puts "Invalid option. Try again"
      return pokemon_selection_index(trainer, current_pokemon, source: source)
    else
      switch_act(trainer, index, source)
    end
  end
  
  def self.select_pokemon(trainer, current_pokemon)
    print "#{trainer.name} select your pokemon: "
    index = gets.chomp.to_i
    new_pokemon = trainer.team[index - 1]
    size = trainer.team.size
    
    if index <= 0 || index > (size + 1) || new_pokemon == current_pokemon || new_pokemon&.fainted?
      puts "Invalid option. Try again"
      return select_pokemon(trainer, current_pokemon)
    else
      (index - 1)
    end
  end
  
  def self.switch_act(trainer, index, source)
    trainer.select_pokemon(index, source)
  end

  def self.go_back(list)
    puts "#{ (list.length) + 1 }- Go back"
    puts
  end
end