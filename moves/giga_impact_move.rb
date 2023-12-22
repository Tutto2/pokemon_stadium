require_relative "move"

class GigaImpactMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns

  def self.learn
    new(
      attack_name: :giga_impact,
      type: Types::NORMAL,
      pp: 5,
      category: :physical,
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