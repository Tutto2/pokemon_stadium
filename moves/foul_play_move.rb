require_relative "move"

class FoulPlayMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(  attack_name: :foul_play,
          type: Types::DARK,
          category: :physical,
          power: 95
        )
  end

  private
  def atk
    pokemon_target.atk
  end
end