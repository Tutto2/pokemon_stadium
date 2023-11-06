require_relative "move"

class ExtremeSpeedMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(  attack_name: :extreme_speed,
          type: Types::NORMAL,
          category: :physical,
          power: 80,
          priority: 2
        )
  end
end
