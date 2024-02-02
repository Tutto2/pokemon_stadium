require_relative "action"
require_relative "attack_action"
require_relative "switch_action"
require_relative "../trainer"
require_relative "../messages_pool"

class Menu
  def self.select_action(trainer, user_pokemon)
    previous_action = trainer.action

    if user_pokemon.is_attacking?
      if previous_action.behaviour.attack_name == :metronome
        previous_action.behaviour = previous_action.behaviour.metadata
        previous_action
      else
        previous_action
      end
    else
      action_num = action_index(trainer, user_pokemon)
      case action_num
      when 1 then attack_select(trainer, previous_action, user_pokemon)
      when 2 then pokemon_selection_index(trainer, user_pokemon)
      end
    end
  end

  def self.action_index(trainer, user_pokemon)
    MessagesPool.display_action_index(trainer, user_pokemon)
    num = gets.chomp.to_i
    pok = user_pokemon

    if num == 2 && !pok.volatile_status[:bound].nil? && !pok.types.include?(Types::GHOST)
      MessagesPool.unable_to_escape_alert(pok.name)
      return action_index(trainer, user_pokemon) 
    end
    return num if num == 1 || num == 2

    MessagesPool.invalid_option
    return action_index(trainer, user_pokemon)
  end

  def self.attack_select(trainer, previous_action, user_pokemon)
    return struggle_move(trainer, user_pokemon) if user_pokemon.has_no_remaining_pp?

    attk_num = select_attack_index(user_pokemon, previous_action)
    if (1..4).include?(attk_num)
      next_attack = user_pokemon.attacks[attk_num - 1]

      if next_attack.attack_name == :baton_pass
        team = trainer.team.reject { |pok| pok == user_pokemon }

        if team.all?(&:fainted?)
          MessagesPool.unable_to_use_attack_alert
          return attack_select(trainer, previous_action, user_pokemon)
        end
      end

      return attack_act(trainer, user_pokemon, next_attack) unless next_attack.pp <= 0
      
      MessagesPool.no_remaining_pp_alert(next_attack.attack_name)
      return attack_select(trainer, previous_action, user_pokemon)
    else
      return select_action(trainer, user_pokemon)
    end
  end

  def self.struggle_move(trainer, user_pokemon)
    MessagesPool.no_remaining_moves_alert(user_pokemon.name)
    target_index = select_target(trainer)

    AttackAction.new(
      speed: user_pokemon.actual_speed,
      behaviour: StruggleMove.learn,
      trainer: trainer,
      user_pokemon: user_pokemon,
      target: target_index
    )
  end

  def self.select_target(trainer)
    opponents = trainer.opponents
    return 0 if opponents.size == 1 && opponents[0].current_pokemons.size == 1
    
    pick_a_target(opponents)
  end

  def self.pick_a_target(opponents)
    show_posible_targets(opponents)
    MessagesPool.opponents_index
    index = gets.chomp.to_i

    if (1..2).include?(index)
      index
    else
      MessagesPool.invalid_option
      return pick_a_target(opponents)
    end
  end

  def self.show_posible_targets(opponents)
    if opponents.size == 1
      opponents[0].current_pokemons.each.with_index(1) do |pok, index|
        MessagesPool.posible_targets(pok, index)
      end
    else
      opponents.each.with_index(1) do |opp, index|
        pok = opp.current_pokemons[0]
        MessagesPool.posible_targets(pok, index)
      end
    end
  end


  def self.select_attack_index(user_pokemon, previous_action)
    user_pokemon.view_attacks
    go_back(user_pokemon.attacks)
    MessagesPool.select_attack_index
    attk_num = gets.chomp.to_i

    if user_pokemon.has_banned_attack? && user_pokemon.attacks[attk_num - 1] == previous_action.behaviour
      MessagesPool.banned_attack_alert
      return select_attack_index(user_pokemon, previous_action)
    end

    return attk_num if (1..5).include?(attk_num)

    MessagesPool.invalid_option
    return select_attack_index(user_pokemon, previous_action)
  end

  def self.attack_act(trainer, user_pokemon, next_attack)
    target_index = select_target(trainer)

    AttackAction.new(
      speed: user_pokemon.actual_speed,
      behaviour: next_attack,
      trainer: trainer,
      user_pokemon: user_pokemon,
      target: target_index
    )
  end
  
  def self.pokemon_selection_index(trainer, user_pokemon, source: nil)
    trainer.view_pokemons
    go_back(trainer.team) if source.nil?
    
    index = select_pokemon(trainer, user_pokemon)
    size = trainer.team.size

    if source.nil? && index == size
      return select_action(trainer, user_pokemon)
    elsif index == size
      MessagesPool.invalid_option
      return pokemon_selection_index(trainer, user_pokemon, source: source)
    else
      switch_act(trainer, user_pokemon, index, source)
    end
  end
  
  def self.select_pokemon(trainer, user_pokemon)
    MessagesPool.select_pokemon_index(trainer.name)
    index = gets.chomp.to_i
    new_pokemon = trainer.team[index - 1]
    size = trainer.team.size
    
    if index <= 0 || index > (size + 1) || new_pokemon == user_pokemon || new_pokemon&.fainted?
      MessagesPool.invalid_option
      return select_pokemon(trainer, user_pokemon)
    else
      (index - 1)
    end
  end
  
  def self.switch_act(trainer, user_pokemon, index, source)
    trainer.select_pokemon(user_pokemon, index, source)
  end

  def self.go_back(list)
    MessagesPool.go_back_index(list)
  end
end