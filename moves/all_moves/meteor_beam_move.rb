require_relative "../move"

class MeteorBeamMove < Move
  include BasicSpecialAtk
  include HasSeveralTurns
  include StatChanges

  def self.learn
    new(
      attack_name: 'Meteor Beam',
      type: Types::NORMAL,
      pp: 10,
      category: :special,
      power: 120
      )
  end

  private

  def first_turn_action
    BattleLog.instance.log(MessagesPool.meteor_beam_msg(pokemon.name))
    stat_changes
  end

  def stat
    [
      [:sp_atk, 1]
    ]
  end

  def second_turn_action
    execute
    end_turn_action
  end
end