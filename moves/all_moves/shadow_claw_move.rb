require_relative "move"

class ShadowClawMove < Move
  include BasicPhysicalAtk
  include HasHighCritRatio

  def self.learn
    new(
      attack_name: 'Shadow Claw',
      type: Types::GHOST,
      pp: 15,
      category: :physical,
      power: 70
      )
  end
end
