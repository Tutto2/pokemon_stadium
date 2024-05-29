require_relative "../move"

class GrowthMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: 'Growth',
      type: Types::NORMAL,
      pp: 20,
      category: :status
      )
  end

  private
  def status_effect(pokemon_target)
    stat_changes
  end

  def stat
    stages = pokemon.trainer.battleground.field.weather&.name == 'Harsh sunlight' ? 2 : 1
    
    [
      [:sp_atk, stages],
      [:atk, stages]
    ]
  end
end
