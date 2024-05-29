require_relative "../move"

class SunnyDayMove < Move
  def self.learn
    new(
      attack_name: 'Sunny Day',
      type: Types::FIRE,
      pp: 5,
      category: :status
      )
  end

  private
  def status_effect(pokemon_target)
    pokemon.trainer.battleground.field.apply_weather(HarshSunlight.new)
  end
end