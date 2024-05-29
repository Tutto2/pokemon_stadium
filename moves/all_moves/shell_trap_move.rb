require_relative "../move"

class ShellTrapMove < Move
  include BasicSpecialAtk
  include HasTrigger

  def self.learn
    new(
      attack_name: 'Shell Trap',
      type: Types::FIRE,
      pp: 5,
      category: :special,
      priority: -3,
      power: 150
      )
  end

  def additional_move(pokemon)
    ShellTrapCharge.learn
  end

  def trigger_perform_fail_msg
    BattleLog.instance.log(MessagesPool.shell_trap_fail_msg(pokemon.name))
  end

  private

  def trigger(pokemon)
    pokemon.got_harm?
  end
end

class ShellTrapCharge < Move
  include HasTrigger

  def self.learn
    new(priority: 6)
  end

  def additional_action(pokemon)
    BattleLog.instance.log(MessagesPool.shell_trap_msg(pokemon.name))
  end
end
