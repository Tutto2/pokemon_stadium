require_relative "move"

class BoomburstMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: :boomburst,
      type: Types::NORMAL,
      pp: 10,
      category: :special,
      power: 140,
      target: 'all_except_self'
      )
  end
end