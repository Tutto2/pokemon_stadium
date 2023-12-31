require_relative "move"

class AttractMove < Move
  def self.learn
    new(
      attack_name: :attract,
      type: Types::NORMAL,
      pp: 15,
      category: :status,
      target: :pokemon_target
      )
  end
  
  private
  def status_effect
    if pokemon.opposite_gender(pokemon_target)
      volatile_status_apply(pokemon_target, InfatuationStatus.get_infatuated)
    end
  end
end