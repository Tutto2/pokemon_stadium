require_relative "../move"

class IcicleSpearMove < Move
  include BasicPhysicalAtk
  include MultiStrikeAtk

  def self.learn
    new(
      attack_name: 'Icecicle Spear',
      type: Types::ICE,
      pp: 30,
      category: :physical,
      power: 25
      )
  end
end
