require_relative "move"

class FrenzyPlantMove < Move
  include BasicSpecialAtk
  include HasSeveralTurns

  def self.learn
    new(
      attack_name: 'Frenzy Plant',
      type: Types::GRASS,
      pp: 5,
      category: :special,
      power: 150,
      precision: 90
    )
  end

  def first_turn_action
    execute
  end

  def second_turn_action
    BattleLog.instance.log(MessagesPool.recharge_msg(pokemon.name, attack_name))
    end_turn_action
  end
end
