require_relative "move"

class FacadeMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: :facade,
      type: Types::NORMAL,
      pp: 20,
      category: :physical
      )
  end

  def power
    condition = pokemon.health_condition

    if condition.nil?
      70
    elsif [:poisoned, :paralyzed, :burned].include?(condition.name)
      70 * 2
    else
      70
    end
  end
end