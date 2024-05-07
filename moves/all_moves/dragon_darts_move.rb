require_relative "../move"

class DragonDartsMove < Move
  include BasicPhysicalAtk
  include MultiStrikeAtk
  # Special thing on doubles

  def self.learn
    new(
      attack_name: 'Dragon Darts',
      type: Types::DRAGON,
      pp: 10,
      category: :physical,
      power: 50
      )
  end

  private
  def hits
    2
  end
end
