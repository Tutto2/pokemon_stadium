require_relative "moves"
require_relative "concerns/move_modifiers"

class GlaiveRushMove < Move
  include BasicPhysicalAtk
  # Makes vulnerable the user for 1 turn (200% dmg && always hit)

  def self.learn
    new(  attack_name: :glaive_rush,
          type: Types::DRAGON,
          category: :physical,
          power: 120
        )
  end
end