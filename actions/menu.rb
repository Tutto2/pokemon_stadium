require_relative "action"
require_relative "attack_action"
require_relative "switch_action"
require_relative "../trainer"
require_relative "../messages_pool"
require_relative "../moves/move"

class Menu
  def self.select_action(trainer, user_pokemon)
    previous_action = trainer.battleground.action_list["#{user_pokemon.name}"]

    if user_pokemon.is_attacking?
      if !previous_action.nil? && previous_action.behaviour.attack_name == :metronome
        previous_action = previous_action.behaviour.metadata
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
        back_up_team = trainer.team.reject { |pok| !pok.field_position.nil? }

        if back_up_team.all?(&:fainted?)
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
    
    AttackAction.new(
      speed: user_pokemon.actual_speed,
      behaviour: StruggleMove.learn,
      trainer: trainer,
      user_pokemon: user_pokemon,
      target: nil
    )
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
    target_index = target_selection(user_pokemon, next_attack.target, trainer.battleground.battle_type)

    AttackAction.new(
      speed: user_pokemon.actual_speed,
      behaviour: next_attack,
      trainer: trainer,
      user_pokemon: user_pokemon,
      target: target_index
    )
  end

  def self.target_selection(user_pokemon, target, battle_type)
    if target == 'one_opp' || target == 'anyone_except_self'
      select_opp(user_pokemon, target, battle_type)
    else
      nil
    end
  end

  def self.select_opp(user_pokemon, target, battle_type)
    field_positions = user_pokemon.trainer.battleground.field.positions
    opponents = field_positions.reject { |i, pok| pok == user_pokemon }

    if battle_type == 'single' || battle_type == 'royale' || target == 'anyone_except_self'
      opponents.size > 1 ? pick_a_target(user_pokemon, opponents, battle_type) : opponents.keys
    else
      user = field_positions.find { |i, pok| pok == user_pokemon }
      user_key = user[0]
      if user_key.even?
        opponents = field_positions.reject { |i, pok| i.even? }
      else
        opponents = field_positions.reject { |i, pok| i.odd? }
      end
      
      pick_a_target(user_pokemon, opponents, battle_type)
    end
  end

  def self.pick_a_target(user_pokemon, targets, battle_type)
    teammate = []
    if battle_type == 'double'
      if user_pokemon.field_position.even?
        targets.each do |i, pok|
          next if i.odd?
          teammate << pok
        end
      else
        battle_type == 'double'
        targets.each do |i, pok|
          next if i.even?
          teammate << pok
        end
      end
    end

    targets = targets.reject { |i, pok| pok == teammate[0] } if !teammate.empty?
    targets = targets.values
    targets = targets + teammate
    targets = targets.flatten

    show_posible_targets(targets)
    MessagesPool.targets_index
    index = gets.chomp.to_i

    if target_index_validation?(targets, index)
      [index]
    else
      MessagesPool.invalid_option
      return pick_a_target(targets)
    end
  end

  def self.show_posible_targets(targets)
    targets.each.with_index(1) do |pok, index|
      MessagesPool.posible_targets(pok, index)
    end
  end
  
  def self.target_index_validation?(targets, index)
    return false if !((1..(targets.size)).include?(index))
    true
  end
  
  def self.pokemon_selection_index(trainer, user_pokemon, source: nil)
    BattleLog.instance.display_messages if source == :baton_pass
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