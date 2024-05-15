require_relative "../move"

class GigatonHammerMove < Move
  include BasicPhysicalAtk
  include PostEffect

  def self.learn
    new(
      attack_name: 'Gigaton Hammer',
      type: Types::STEEL,
      pp: 5,
      category: :physical,
      power: 160
      )
  end

  def post_effect(pokemon)
    pokemon.metadata[:banned] = "last attack"
  end
end
