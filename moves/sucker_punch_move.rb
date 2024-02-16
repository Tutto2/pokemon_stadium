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
    index = 0
    pokemon_target.trainer.current_pokemons.each.with_index do |curr_pok, i|
      index = i if curr_pok == pokemon_target
    end
    atk = pokemon_target.trainer.action[index]

    atk.behaviour.category != :status && target_slower?(atk) ? 100 : 0
  end

  def target_slower?(atk)
    atk.priority < self.priority || (atk.priority == self.priority && pokemon_target.actual_speed < pokemon.actual_speed)
  end
end