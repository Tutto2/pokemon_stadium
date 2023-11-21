require_relative "moves/move"

class ActionQueue < Action
  attr_reader :priority_table

  def initialize(priority_table: {})
    @priority_table = {
      8 => [],
      7 => [],
      6 => [],
      5 => [],
      4 => [],
      3 => [],
      2 => [],
      1 => [],
      0 => [],
      -1 => [],
      -2 => [],
      -3 => [],
      -4 => [],
      -5 => [],
      -6 => [],
      -7 => []
    }
  end

  def <<(action)
    return @priority_table[action.priority] << action if action.action_type != :atk_action
    
    move = action.action
    if move.has_additional_action?
      actions = [action, move.additional_action]
      actions.each do |action|
        @priority_table[action.priority] << action
      end
    end
  end
end