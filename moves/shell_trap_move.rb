require_relative "move"

class ShellTrapMove < Move
  include BasicSpecialAtk
  include HasTrigger

  def self.learn
    new(
      attack_name: :shell_trap,
      type: Types::FIRE,
      pp: 5,
      category: :special,
      priority: -3,
      power: 150
      )
  end

  def additional_move
    ShellTrapCharge.learn
  end

  private

  def trigger(pokemon)
    pokemon.got_harm?
  end
end

class ShellTrapCharge < Move
  include HasTrigger

  def self.learn
    new(priority: 6)
  end

  def additional_action(pokemon)
    puts "#{pokemon.name} set a shell trap."
  end
end