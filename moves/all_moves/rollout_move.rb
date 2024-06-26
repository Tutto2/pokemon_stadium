require_relative "../move"

class RolloutMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns

  def self.learn
    attr_reader :chain

    new(
      attack_name: 'Rollout',
      type: Types::ROCK,
      pp: 20,
      category: :physical,
      precision: 90
      )
  end

  def power
    pwr = 30 * (2 ** chain)
    if pokemon.has_power_up?
      pwr * 2
    else
      pwr
    end
  end

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
