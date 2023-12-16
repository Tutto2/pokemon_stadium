require_relative "move"

class GlaiveRushMove < Move
  include BasicPhysicalAtk
  include PostEffect

  def self.learn
    new(
      attack_name: :glaive_rush,
      type: Types::DRAGON,
      pp: 5,
      category: :physical,
      power: 120
      )
  end

  private
  def post_effect(pokemon)
    pokemon.metadata = {post_effect: "vulnerable"}
    puts "#{pokemon.name} is vulnerable"
  end
end