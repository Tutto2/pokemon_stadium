require_relative "move"

class SuckerPunchMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: :sucker_punch,
      type: Types::DARK,
      pp: 5,
      category: :physical,
      priority: 1,
      power: 70
      )
  end

  def precision
    pokemon_target = targets[0]
    index = pokemon_target.field_position > 2 ? 1 : 0
    atk = pokemon_target.trainer.action[index]

    return 0 if atk.behaviour.is_a?(Pokemon)

    atk.behaviour.category != :status && target_slower?(pokemon_target, atk) ? 100 : 0
  end

  def target_slower?(pokemon_target, atk)
    atk.priority < self.priority || (atk.priority == self.priority && pokemon_target.actual_speed < pokemon.actual_speed)
  end
end