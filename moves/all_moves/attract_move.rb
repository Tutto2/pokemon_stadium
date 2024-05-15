require_relative "../move"

class AttractMove < Move
  def self.learn
    new(
      attack_name: 'Attract',
      type: Types::NORMAL,
      pp: 15,
      category: :status,
      target: 'one_opp'
      )
  end
  
  private
  def status_effect(pokemon_target)
    if pokemon.opposite_gender(pokemon_target)
      volatile_status_apply(pokemon_target, InfatuationStatus.get_infatuated)
    end
  end
end
