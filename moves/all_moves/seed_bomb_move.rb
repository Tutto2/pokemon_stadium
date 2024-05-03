require_relative "move"

class SeedBombMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Seed Bomb',
      type: Types::GRASS,
      pp: 15,
      category: :physical,
      power: 80
      )
  end
end
