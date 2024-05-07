require_relative "../move"

class HexMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: 'Hex',
      type: Types::GHOST,
      pp: 10,
      category: :special
      )
  end

  def power
    pokemon_target.health_condition.nil? ? 65 : 130
  end
end
