require_relative "moves"

class PowerGemMove < Move
  include BasicSpecialAtk

  def self.learn
    new(  attack_name: :power_gem,
          type: Types::ROCK,
          category: :special,
          power: 80
        )
  end
end