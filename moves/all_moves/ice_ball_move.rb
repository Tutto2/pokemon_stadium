require_relative "../move"

class IceBallMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns

  def self.learn
    new(
      attack_name: 'Ice Ball',
      type: Types::ICE,
      pp: 20,
      category: :physical,
      precision: 90
      )
  end

  def power
    power = 30 * (2 ** chain)
    if pokemon.has_power_up?
      power * 2
    else
      power
    end
  end

  private
  attr_reader :chain

  def first_turn_action
    @chain = 0
    execute
  end

  def second_turn_action
    @chain = 1
    execute
  end

  def third_turn_action
    @chain = 2
    execute
  end

  def fourth_turn_action
    @chain = 3
    execute
  end

  def fifth_turn_action
    @chain = 4
    execute
    end_turn_action
  end
end
