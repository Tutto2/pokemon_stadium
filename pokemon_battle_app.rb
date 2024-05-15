require_relative "interface/game_options"
require_relative "interface/load_options"
require_relative "messenger/messages_pool"
require_relative "messenger/battle_log"

class PokemonBattleApp
  def self.new_game
    game_settings_interface == 1 ? GameOptions.battle_settings : LoadOptions.load_interface
  end

  def self.game_settings_interface
    option = 0
    MessagesPool.interface_index
    loop do
      MessagesPool.select_first_action
      option = gets.chomp.to_i
      
      break if [1, 2].include?(option)
      MessagesPool.invalid_option
    end

    option
  end
end

puts PokemonBattleApp.new_game