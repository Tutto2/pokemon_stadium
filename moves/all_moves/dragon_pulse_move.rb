require_relative "../move"

class DragonPulseMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: 'Dragon Pulse',
      type: Types::DRAGON,
      pp: 10,
      category: :special,
      power: 85
      )
  end
end