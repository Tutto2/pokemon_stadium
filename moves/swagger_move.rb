require_relative "move"

class SwaggerMove < Move
  include HasSecondaryEffect
  include StatChanges
  
  def self.learn
    new(  attack_name: :swagger,
          type: Types::NORMAL,
          category: :status,
          precision: 85
        )
  end
  
  private
  def status_effect
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:atk, 2]
    ]
  end

  def secondary_effect
    volatile_condition_apply(pokemon_target, ConfusionStatus.get_confused(pokemon_target))
  end

  def trigger_chance
    1
  end
end