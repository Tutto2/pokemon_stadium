require_relative "../pokemon/pokemon"

class Action
  attr_reader :speed, :action, :trainer, :target, :priority
  
  def initialize(speed:, action:, trainer:, target:, priority:)
    @speed = speed
    @action = action
    @trainer = trainer
    @target = target
    @priority = priority
  end

  def perfom; end

  def <=>(other)
    self.speed <=> other.speed
  end
end