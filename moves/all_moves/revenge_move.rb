require_relative "../move"

class RevengeMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Revenge',
      type: Types::FIGHTING,
      pp: 10,
      category: :physical,
      priority: -4
      )
  end

  def power
    pokemon.got_harm? ? 120 : 60
  end
end