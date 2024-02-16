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
        back_up_team = trainer.team.reject { |pok| trainer.battleground.field.positions.values.include?(pok) }

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
    target_index = auto_target_select(user_pokemon, 'random_opp', battle_type)

    AttackAction.new(
      speed: user_pokemon.actual_speed,
      behaviour: StruggleMove.learn,
      trainer: trainer,
      user_pokemon: user_pokemon,
      target: target_index
    )
  end

  def self.select_attack_index(user_pokemon, previous_action)
    user_pokemon.view_attacks
    go_back(user_pokemon.attacks)
    MessagesPool.select_attack_index
    attk_num = gets.chomp.to_i

    if user_pokemon.has_banned_attack? && user_pokemon.attacks[attk_num - 1] == previous_action
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
    target == 'one_opp' ? select_opp(user_pokemon, battle_type) : auto_target_select(user_pokemon, target, battle_type)
  end

  def self.select_opp(user_pokemon, battle_type)
    field_positions = user_pokemon.trainer.battleground.field.positions

    if battle_type == 'single' || battle_type == 'royale'
      opponents = field_positions.reject { |i, pok| pok == user_pokemon }

      opponents.size > 1 ? pick_a_target(opponents) : opponents.keys
    else
      user = field_positions.find { |i, pok| pok == user_pokemon }
      user_key = user[0]
      if user_key.even?
        opponents = field_positions.reject { |i, pok| i.even? }
      else
        opponents = field_positions.reject { |i, pok| i.odd? }
      end
      pick_a_target(opponents)
    end
  end

  def self.pick_a_target(targets)
    show_posible_targets(targets.values)
    MessagesPool.targets_index
    index = gets.chomp.to_i

    if target_index_validation?(targets, index)
      [targets.keys[index]]
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

  def self.auto_target_select(user_pokemon, target, battle_type)
    field_position = user_pokemon.trainer.battleground.field.positions
    user_position = field_position.find { |i, pok| pok == user_pokemon }

    case target
    when 'self'
      [user_position[0]]
    when 'all_opps'
      both_opponents_selection(field_position, user_position)
    when 'random_opp'
      random_opponent_selection(user_pokemon, field_position, user_position, battle_type)
    when 'teammate'
      battle_type == 'double' ? teammate_selection(user_pokemon, field_position, user_position) : [nil]
    when 'all_except_self'
      all_others = field_position.reject { |i, pok| pok == user_pokemon }
      all_others.keys
    end
  end

  def both_opponents_selection(field_position, user_position)
    opponents = {}
    if user_position[0].even?
      opponents = field_positions.reject { |i, pok| i.even? }
    else
      opponents = field_positions.reject { |i, pok| i.odd? }
    end
    opponents.keys
  end

  def random_opponent_selection(user_pokemon, field_position, user_position, battle_type)
    if battle_type == 'double'
      [both_opponents_selection(field_position, user_position).sample]
    else
      opponents = field_position.reject { |i, pok| pok == user_pokemon }
      [opponents.keys.sample]
    end
  end

  def teammate_selection(user_pokemon, field_position, user_position)
    allies = {}
    if user_position[0].even?
      allies = field_positions.reject { |i, pok| i.odd? }
    else
      allies = field_positions.reject { |i, pok| i.even? }
    end

    teammate = allies.reject { |i, pok| pok == user_pokemon }
    teammate.keys
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