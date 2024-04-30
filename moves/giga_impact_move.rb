require_relative "move"

class GigaImpactMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns

  def self.learn
    new(
      attack_name: 'Giga Impact',
      type: Types::NORMAL,
      pp: 5,
      category: :physical,
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
