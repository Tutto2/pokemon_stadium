require_relative "move"

class SolarBladeMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns

  def self.learn
    new(
      attack_name: :solar_blade,
      type: Types::GRASS,
      pp: 10,
      category: :physical,
      power: 125
      )
  end

  private

  def first_turn_action
    puts "The attack is charging"
    puts
  end

  def second_turn_action
    execute
    end_turn_action
  end
end