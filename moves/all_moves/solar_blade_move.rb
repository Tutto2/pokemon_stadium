require_relative "../move"

class SolarBladeMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns

  def self.learn
    new(
      attack_name: 'Solar Blade',
      type: Types::GRASS,
      pp: 10,
      category: :physical,
      power: 125
      )
  end

  private

  def first_turn_action
    if pokemon.trainer.battleground.field.weather&.name == 'Harsh sunlight'
      execute
      end_turn_action
    else  
      BattleLog.instance.log(MessagesPool.charging_atk_msg)
    end
  end

  def second_turn_action
    execute
    end_turn_action
  end
end
