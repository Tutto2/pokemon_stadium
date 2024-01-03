require_relative "move"

class CounterMove < Move
  include BasicPhysicalAtk
  include TakeDmgBack

  def self.learn
    new(
      attack_name: :counter,
      type: Types::FIGHTING,
      pp: 20,
      category: :physical,
      priority: -5,
      power: 1
      )
  end

  def triggered?
    pokemon.was_touched?
  end
end