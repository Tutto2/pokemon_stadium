require_relative "move"

class IceBallMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns

  def self.learn
    new(  attack_name: :ice_ball,
          type: Types::ICE,
          category: :physical,
          precision: 90
        )
  end

  private
  attr_reader :chain

  def first_turn_action
    @chain = 0
    perform
  end

  def second_turn_action
    @chain = 1
    perform
  end

  def third_turn_action
    @chain = 2
    perform
  end

  def fourth_turn_action
    @chain = 3
    perform
  end

  def fifth_turn_action
    @chain = 4
    perform
    end_turn_action
  end

  def power
    30 * (2 ** @chain)
  end
end