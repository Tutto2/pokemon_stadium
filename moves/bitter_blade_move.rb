require_relative "move"

class BitterBladeMove < Move
  include BasicPhysicalAtk
  include DrainingAttack

  def self.learn
    new(
      attack_name: :bitter_blade,
      type: Types::FIRE,
      pp: 10,
      category: :physical,
      power: 90
    )
  end
end