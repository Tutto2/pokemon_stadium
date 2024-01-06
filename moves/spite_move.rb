require_relative "move"

class SpiteMove < Move
  def self.learn
    new(
      attack_name: :spite,
      type: Types::GHOST,
      pp: 10,
      category: :status
      )
  end

  private
  def status_effect
    previous_action = pokemon_target.trainer.action.behaviour

    if previous_action.is_a?(Move)
      puts "It reduced the PP of #{pokemon_target.name}'s #{previous_action.attack_name} by 4"
      (previous_action.pp -= 4).clamp(0, 40)
    else
      puts "The attack has failed"
    end
  end
end