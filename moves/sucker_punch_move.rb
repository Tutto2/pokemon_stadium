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
    if pokemon_target.trainer.action.priority < pokemon.trainer.action.priority ||
      (pokemon_target.trainer.action.priority == pokemon.trainer.action.priority &&
       pokemon_target.actual_speed < pokemon.actual_speed)
      category = pokemon_target.trainer.action.behaviour.category
      category == :physical || category == :special ? 100 : 0
    else
      0
    end
  end
end