require_relative 'battleground'

class GameOptions
  def self.battle_settings
    battle_format = ''
    battle_index = 0

    MessagesPool.battle_settings_options
    loop do
      MessagesPool.select_battle_settings
      battle_index = gets.chomp.to_i

      break if (1..4).include?(battle_index)
      MessagesPool.invalid_option
    end

    return PokemonBattleApp.new_game if battle_index == 4

    battle_format = case battle_index
    when 1 then 'single'
    when 2 then 'double'
    when 3 then 'royale'
    end

    init_battle(battle_format)
  end

  def self.init_battle(battle_format)
    players_num = select_trainers_number(battle_format)
    
    battle = Battleground.new(players: players_num, battle_type: battle_format)
    battle.select_players_names
    battle.choose_pokemons

    battle.start_battle
  end

  def self.select_trainers_number(battle_format)
    return 2 if battle_format == 'single'
    players_num = 0

    MessagesPool.select_players_num
    loop do
      players_num = gets.chomp.to_i

      break if [0, 2, 4].include?(players_num) && battle_format == 'double'
      break if [0, 3, 4].include?(players_num) && battle_format == 'royale'
      MessagesPool.invalid_option
    end

    return battle_settings if players_num == 0
    players_num
  end
end