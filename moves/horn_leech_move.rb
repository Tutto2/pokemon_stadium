require_relative "move"

class HornLeechMove < Move
  include BasicPhysicalAtk
  include DrainingAttack

  def self.learn
    new(
      attack_name: :horn_leech,
      type: Types::GRASS,
      pp: 10,
      category: :physical,
      power: 75
    )
  end
end