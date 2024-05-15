require_relative "action"
require_relative "../trainer"

class SwitchAction < Action
  def initialize(**args) 
    super(priority: 6, **args)
  end
  
  def perform
    BattleLog.instance.log(MessagesPool.leap)
    next_pokemon = behaviour
    BattleLog.instance.log(MessagesPool.switch_action_msg(next_pokemon.name))
    
    field_positions = trainer.battleground.field.positions
    user = user_pokemon.field_position

    field_positions[user] = next_pokemon
  end
end