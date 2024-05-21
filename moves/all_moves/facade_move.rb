require_relative "../move"

class FacadeMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Facade',
      type: Types::NORMAL,
      pp: 20,
      category: :physical
      )
  end

  def power
    condition = pokemon.health_condition
    return 70 if condition.nil?

    [:poisoned, :paralyzed, :burned].include?(condition.name) ? 140 : 70
  end
end
