require_relative "move"

class PowerGemMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: :power_gem,
      type: Types::ROCK,
      pp: 20,
      category: :special,
      power: 80
      )
  end
end