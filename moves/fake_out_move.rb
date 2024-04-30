require_relative "move"

class FakeOutMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include CanFlinch

  def self.learn
    new(
      attack_name: 'Fake Out',
      type: Types::NORMAL,
      pp: 10,
      category: :physical,
      power: 40,
      priority: 3
      )
  end

  def trigger_chance
    1
  end

  def precision
    pokemon.metadata[:actions] == 0 ? 100 : 0
  end
end
