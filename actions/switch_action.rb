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
    user = field_positions.find { |i, pok| pok == user_pokemon }

    field_positions[user[0]] = next_pokemon
  end
end