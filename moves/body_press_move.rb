require_relative "move"

class BodyPressMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: :body_press,
      type: Types::NORMAL,
      pp: 10,
      category: :physical,
      power: 80
      )
  end

  private
  def atk
    pokemon.def
  end
end