require_relative "../move"

class FlyMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns

  def self.learn
    new(
      attack_name: 'Fly',
      type: Types::FLYING,
      pp: 15,
      category: :physical,
      power: 90,
      precision: 95
      )
  end

  def first_turn_action
    BattleLog.instance.log(MessagesPool.fly_msg(pokemon.name))
    pokemon.make_invulnerable(self.attack_name)
  end

  def second_turn_action
    execute
    pokemon.vulnerable_again
    end_turn_action
  end
end
