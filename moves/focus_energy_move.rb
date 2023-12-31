require_relative "move"

class FocusEnergyMove < Move
  def self.learn
    new(
      attack_name: :focus_energy,
      type: Types::NORMAL,
      pp: 30,
      category: :status
      )
  end

  def status_effect
    pokemon.increase_crit_stage(2)
  end
end