require_relative "move"

class FocusPunchMove < Move
  include BasicPhysicalAtk
  include HasTrigger

  def self.learn
    new(
      attack_name: :focus_punch,
      type: Types::FIGHTING,
      pp: 20,
      category: :physical,
      priority: -3,
      power: 150
      )
  end

  def additional_move
    FocusPunchCharge.learn
  end

  private

  def trigger(pokemon)
    !pokemon.got_harm?
  end
end

class FocusPunchCharge < Move
  include HasTrigger

  def self.learn
    new(priority: 6)
  end

  def additional_action(pokemon)
    BattleLog.instance.log(MessagesPool.focus_punch_msg(pokemon.name))
  end
end