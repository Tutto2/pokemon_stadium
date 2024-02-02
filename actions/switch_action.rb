require_relative "../trainer"

class SwitchAction < Action
  def initialize(**args) 
    super(priority: 6, **args)
  end
  
  def perform
    BattleLog.instance.log(MessagesPool.leap)
    next_pokemon = behaviour
    BattleLog.instance.log(MessagesPool.switch_action_msg(next_pokemon.name))
    
    @trainer.current_pokemons.map! do |pok|
      pok == user_pokemon ? next_pokemon : pok
    end

    # @trainer.battlefield.field_positions.map! do |position, pok|
    #   if pok == user_pokemon
    #     field_positions[position] = next_pokemon
    #   end
    # end
  end
end