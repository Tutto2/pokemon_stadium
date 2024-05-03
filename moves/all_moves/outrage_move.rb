require_relative "move"

class OutrageMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns

  def self.learn
    new(
      attack_name: 'Outrage',
      type: Types::DRAGON,
      pp: 10,
      category: :physical,
      power: 120,
      target: 'random_opp'
      )
  end

  private

  def first_turn_action
    execute
  end

  def second_turn_action
    execute
    if rand < 0.5
      final
    end
  end

  def third_turn_action
    execute
    final
  end

  def final
    end_turn_action
    volatile_status_apply(pokemon, ConfusionStatus.get_confused)
  end
end
