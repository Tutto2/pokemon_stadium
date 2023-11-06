require_relative "move"


class SolarBladeMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns
  # Agregar tipo fuego?

  def self.learn
    new(  attack_name: :solar_blade,
          type: Types::GRASS,
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
    perform
    end_turn_action
  end
end