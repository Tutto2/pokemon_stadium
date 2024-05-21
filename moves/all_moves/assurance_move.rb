require_relative "../move"

class AssuranceMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Assurance',
      type: Types::DARK,
      pp: 10,
      category: :physical
      )
  end

  def power
    pokemon.got_harm? ? 120 : 60
  end
end