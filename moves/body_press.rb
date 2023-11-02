require_relative "moves"

class BodyPressMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(  attack_name: :body_press,
          type: Types::NORMAL,
          category: :physical,
          power: 80
        )
  end

  private
  def atk
    pokemon.def
  end
end