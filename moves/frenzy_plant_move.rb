require_relative "move"

class FrenzyPlantMove < Move
  include BasicSpecialAtk
  include HasSeveralTurns

  def self.learn
    new(
      attack_name: :frenzy_plant,
      type: Types::GRASS,
      pp: 5,
      category: :special,
      power: 150,
      precision: 90
    )
  end

  def first_turn_action
    execute
  end

  def second_turn_action
    puts "#{pokemon.name} is recharging after using #{attack_name}"
    end_turn_action
  end
end