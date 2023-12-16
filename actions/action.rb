require_relative "../pokemon/pokemon"

class Action
  attr_reader :speed, :behaviour, :trainer, :target, :priority
  
  def initialize(speed:, behaviour:, trainer:, target: nil, priority:)
    @speed = speed
    @behaviour = behaviour
    @trainer = trainer
    @target = target
    @priority = priority
  end

  def perfom; end

  def <=>(other)
    self.speed <=> other.speed
  end

  def enqueueable
    [self]
  end
end