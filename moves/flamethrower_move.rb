require_relative "moves"

class FlamethrowerMove < Move
  include BasicSpecialAtk
  # Can burn 10%

  def self.learn
    new(  attack_name: :flamethrower,
          type: Types::FIRE,
          category: :special,
          power: 90
        )
  end
end