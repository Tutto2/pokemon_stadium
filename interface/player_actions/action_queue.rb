require_relative "action"
require_relative "../../moves/move"

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
    action.enqueueable.each do |a|
      @priority_table[a.priority] << a
    end
  end

  def perform_actions
    priority_table.each { |_, actions| actions.sort(&sort_order).each(&:perform) }
  end

  private

  def sort_order
    sort_desc 
  end

  def sort_asc
    ->(a, b) { a <=> b }
  end

  def sort_desc
    ->(a, b) { b <=> a }
  end
end