require_relative "move"

class SynthesisMove < Move
  include HpChange
  # Chance amount of healing depending on weather

  def self.learn
    new(
      attack_name: :synthesis,
      type: Types::GRASS,
      pp: 5,
      category: :status,
      precision: nil
      )
  end

  private
  def status_effect
    gain_hp
  end

  def value
    0.5 * pokemon.hp_total
  end
end