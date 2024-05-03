require_relative "move"

class FoulPlayMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Foul Play',
      type: Types::DARK,
      pp: 15,
      category: :physical,
      power: 95
      )
  end

  private
  def atk
    pokemon_target.atk
  end
end
