require_relative "../move"

class ThunderMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Thunder',
      type: Types::ELECTRIC,
      pp: 10,
      category: :special,
      power: 110
      )
  end

  def secondary_effect
    health_condition_apply(pokemon_target, ParalysisCondition.get_paralyzed)
  end

  def trigger_chance
    0.3
  end

  def precision
    return 70 if pokemon.trainer.battleground.field.weather.nil?
    weather = pokemon.trainer.battleground.field.weather.name

    case weather
    when 'Harsh sunlight'
      50
    else
      70
    end
  end
end
