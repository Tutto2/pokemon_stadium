class GameOptions
  def self.game_settings_interface
    option = 0
    MessagesPool.interface_index
    loop do
      MessagesPool.select_first_action
      option = gets.chomp.to_i
      
      break if [1, 2].include?(option)
      MessagesPool.invalid_option
    end

    option == 1 ? battle_settings : load_interface
  end

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

    return game_settings_interface if battle_index == 4

    battle_format = case battle_index
    when 1 then 'single'
    when 2 then 'double'
    when 3 then 'royale'
    end

    select_trainers_number(battle_format)
  end

  def self.select_trainers_number(battle_format)
    return [2, battle_format] if battle_format == 'single'
    players_num = 0

    MessagesPool.select_players_num
    loop do
      players_num = gets.chomp.to_i

      break if [0, 2, 3, 4].include?(players_num)
      MessagesPool.invalid_option
    end

    return battle_settings if players_num == 0

    [players_num, battle_format]
  end

  def self.load_interface
    
  end
end