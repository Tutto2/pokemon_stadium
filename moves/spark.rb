require_relative "moves"
require_relative "concerns/move_modifiers"

class SparkMove < Move
  include BasicSpecialAtk
  # 30% parali

  def self.learn
    new(  attack_name: :spark,
          type: Types::ELECTRIC,
          category: :special,
          power: 65
        )
  end
end
