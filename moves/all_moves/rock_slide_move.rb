require_relative "../move"

class RockSlideMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include CanFlinch

  def self.learn
    new(
      attack_name: 'Rock Slide',
      type: Types::ROCK,
      pp: 15,
      category: :physical,
      power: 75,
      precision: 90,
      target: 'all_opps'
      )
  end
end
