require_relative "move"

class SkullBashMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns
  include StatChanges

  def self.learn
    new(  attack_name: :skul_bash,
          type: Types::NORMAL,
          category: :physical,
          power: 130
        )
  end

  private

  def first_turn_action
    puts "#{pokemon.name} lowered his head"
    stat_changes
    puts
  end

  def stat
    [
      [:def, 1]
    ]
  end

  def second_turn_action
    perform
    end_turn_action
  end
end