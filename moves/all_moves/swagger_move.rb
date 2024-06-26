require_relative "../move"

class SwaggerMove < Move
  include HasSecondaryEffect
  include StatChanges
  
  def self.learn
    new(
      attack_name: 'Swagger',
      type: Types::NORMAL,
      pp: 20,
      category: :status,
      precision: 85,
      target: 'one_opp'
      )
  end
  
  private
  def status_effect(pokemon_target)
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:atk, 2]
    ]
  end

  def secondary_effect
    volatile_status_apply(pokemon_target, ConfusionStatus.get_confused)
  end

  def trigger_chance
    1
  end
end
