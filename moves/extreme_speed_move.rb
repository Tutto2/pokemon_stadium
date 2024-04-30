require_relative "move"

class ExtremeSpeedMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Extreme Speed',
      type: Types::NORMAL,
      pp: 5,
      category: :physical,
      power: 80,
      priority: 2
      )
  end
end
