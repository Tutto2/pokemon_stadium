require_relative "move"

class OutrageMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns
  # Cause confusion

  def self.learn
    new(  attack_name: :outrage,
          type: Types::DRAGON,
          category: :physical,
          power: 120
        )
  end

  private

  def first_turn_action
    execute
  end

  def second_turn_action
    execute
    end_turn_action if rand < 0.5
  end

  def third_turn_action
    execute
    end_turn_action
  end
end