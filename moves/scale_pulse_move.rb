require_relative "move"

class ScalePulseMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: :scale_pulse,
      type: Types::BUG, 
      secondary_type: Types::DRAGON,
      pp: 5,
      category: :special,
      power: 85
      )
  end

  private
  def dfn
    pokemon_target.def
  end
end