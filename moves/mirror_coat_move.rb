require_relative "move"

class MirrorCoatMove < Move
  include BasicSpecialAtk
  include TakeDmgBack

  def self.learn
    new(
      attack_name: 'Mirror Coat',
      type: Types::PSYCHIC,
      pp: 20,
      category: :special,
      priority: -5,
      power: 1
      )
  end

  def triggered?
    !pokemon.was_touched? && pokemon.got_harm?
  end
end
