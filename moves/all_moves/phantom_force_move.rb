require_relative "../move"

class PhantomForceMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns
  include ProtectionBreak

  def self.learn
    new(
      attack_name: 'Phantom Force',
      type: Types::GHOST,
      pp: 10,
      category: :special,
      power: 90
      )
  end

  def first_turn_action
    BattleLog.instance.log(MessagesPool.phantom_force_msg(pokemon.name))
    pokemon.make_invulnerable(self.attack_name)
  end

  def second_turn_action
    protect_evaluation(targets[0])
    execute
    pokemon.vulnerable_again
    end_turn_action
  end
end
