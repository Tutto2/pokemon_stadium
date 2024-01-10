require_relative "move"

class PsyshockMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: :psyshock,
      type: Types::PSYCHIC,
      pp: 10,
      category: :special,
      power: 80
      )
  end

  def dfn
    pokemon_target.def
  end
end