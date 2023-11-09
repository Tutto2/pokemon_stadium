require_relative "move"

class GigatonHammerMove < Move
  include BasicPhysicalAtk
  include PostEffect

  def self.learn
    new(  attack_name: :gigaton_hammer,
          type: Types::STEEL,
          category: :physical,
          power: 160
        )
  end

  private

  def post_effect(pokemon)
    pokemon.metadata = {banned: "last attack"}
  end
end