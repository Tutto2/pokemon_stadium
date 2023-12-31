require_relative "move"

class WoodHammerMove < Move
  include BasicPhysicalAtk
  include HasRecoil

  def self.learn
    new(
      attack_name: :wood_hammer,
      type: Types::GRASS,
      pp: 15,
      category: :physical,
      power: 120
      )
  end

  def recoil_factor
    1.0/3.0
  end
end