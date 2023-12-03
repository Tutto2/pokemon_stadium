require_relative "move"

class ShadowClawMove < Move
  include BasicPhysicalAtk
  include HasHighCritRatio

  def self.learn
    new(  attack_name: :shadow_claw,
          type: Types::GHOST,
          category: :physical,
          power: 70
        )
  end
end