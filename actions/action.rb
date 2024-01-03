require_relative "../pokemon/pokemon"

class Action
  attr_reader :speed, :behaviour, :trainer, :user_pokemon, :target, :priority
  
  def initialize(speed:, behaviour:, trainer:, user_pokemon: nil, target: nil, priority:)
    @speed = speed
    @behaviour = behaviour
    @trainer = trainer
    @user_pokemon = user_pokemon
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