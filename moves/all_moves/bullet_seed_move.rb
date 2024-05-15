require_relative "../move"

class BulletSeedMove < Move
  include BasicPhysicalAtk
  include MultiStrikeAtk

  def self.learn
    new(
      attack_name: 'Bullet Seed',
      type: Types::GRASS,
      pp: 30,
      category: :physical,
      power: 25
      )
  end
end
