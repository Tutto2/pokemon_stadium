require_relative "moves"
require_relative "concerns/move_modifiers"

class GigatonHammerMove < Move
  include BasicPhysicalAtk
  # Cannot hit in succession

  def self.learn
    new(  attack_name: :gigaton_hammer,
          type: Types::STEEL,
          category: :physical,
          power: 160
        )
  end
end