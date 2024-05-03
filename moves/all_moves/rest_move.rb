require_relative "move"

class RestMove < Move
  include HpChange
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Rest',
      type: Types::PSYCHIC,
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
    pokemon.hp_total
  end

  def secondary_effect
    health_condition_apply(pokemon, SleepCondition.get_asleep(2))
  end

  def trigger_chance
    1
  end
end
