require_relative "../move"

class SynthesisMove < Move
  include HpChange

  def self.learn
    new(
      attack_name: 'Synthesis',
      type: Types::GRASS,
      pp: 5,
      category: :status,
      precision: nil
      )
  end

  private
  def status_effect(pokemon_target)
    gain_hp
  end

  def value
    weather = pokemon.trainer.battleground.field.weather
    
    if weather.nil? || weather&.name == 'Strong winds'
      0.5 * pokemon.hp_total
    elsif weather&.name == 'Harsh sunlight'
      (2 * pokemon.hp_total) / 3
    else
      0.25 * pokemon.hp_total
    end
  end
end
