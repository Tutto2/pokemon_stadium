require_relative "move"

class SeedBombMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(  attack_name: :seed_bomb,
          type: Types::GRASS,
          category: :physical,
          power: 80
        )
  end
end