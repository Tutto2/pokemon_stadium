require_relative "moves"
require_relative "concerns/move_modifiers"

class BulletSeedMove < Move
  include BasicPhysicalAtk
  include MultiStrikeAtk

  def self.learn
    new(  attack_name: :bullet_seed,
          type: Types::GRASS,
          category: :physical,
          power: 25
        )
  end
end