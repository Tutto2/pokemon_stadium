require_relative "moves"
require_relative "concerns/move_modifiers"

class DragonDartsMove < Move
  include BasicPhysicalAtk
  include MultiStrikeAtk
  # Special thing on doubles

  def self.learn
    new(  attack_name: :dragon_darts,
          type: Types::DRAGON,
          category: :physical,
          power: 50
        )
  end

  private
  def hits
    2
  end
end