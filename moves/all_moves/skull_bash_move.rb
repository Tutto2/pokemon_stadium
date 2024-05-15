require_relative "../move"

class SkullBashMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns
  include StatChanges

  def self.learn
    new(
      attack_name: 'Skull Bash',
      type: Types::NORMAL,
      pp: 10,
      category: :physical,
      power: 130
      )
  end

  private

  def first_turn_action
    BattleLog.instance.log(MessagesPool.skull_bash_msg(pokemon.name))
    stat_changes
  end

  def stat
    [
      [:def, 1]
    ]
  end

  def second_turn_action
    execute
    end_turn_action
  end
end
