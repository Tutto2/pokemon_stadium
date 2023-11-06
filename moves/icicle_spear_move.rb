require_relative "move"


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