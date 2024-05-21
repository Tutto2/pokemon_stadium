require_relative "../move"

class PowerWhipMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Power Whip',
      type: Types::GRASS,
      pp: 10,
      category: :physical,
      precision: 85,
      power: 120
      )
  end
end