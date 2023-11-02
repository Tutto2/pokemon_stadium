require_relative "moves"
require_relative "concerns/move_modifiers"

class IcicleSpearMove < Move
  include BasicPhysicalAtk
  include MultiStrikeAtk

  def self.learn
    new(  attack_name: :icecicle_spear,
          type: Types::ICE,
          category: :physical,
          power: 25
        )
  end
end