require_relative "health_conditions"

class SleepCondition < HealthConditions
  attr_reader :sleep_turns
  
  def self.get_asleep(turns = rand(1..3))
    new(name: :asleep, sleep_turns: turns)
  end

  def initialize(name:, sleep_turns:, immune_type: [])
    @name = name
    @sleep_turns = sleep_turns
    @immune_type = immune_type

    init_count
  end

  def unable_to_move
    true
  end

  def wake_up?
    turn > sleep_turns
  end
end