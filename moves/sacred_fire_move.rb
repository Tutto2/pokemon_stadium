require_relative "move"


class SacredFireMove < Move
  include BasicSpecialAtk
  # 50% burn target

  def self.learn
    new(  attack_name: :sacred_fire,
          type: Types::FIRE,
          category: :special,
          precision: 95,
          power: 100
        )
  end
end