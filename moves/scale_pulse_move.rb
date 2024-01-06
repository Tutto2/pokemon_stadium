require_relative "move"

class ScalePulseMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: :scale_pulse,
      type: Types::BUG, 
      secondary_type: Types::DRAGON,
      pp: 5,
      category: :special
      )
  end

  def power
    rand > 0.2 ? 85 : 170
  end

  def dfn
    pokemon_target.def
  end
end