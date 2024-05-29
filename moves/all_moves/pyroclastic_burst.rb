require_relative "../move"

class PyroclasticBurstMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: 'Pyroclastic Burst',
      type: Types::FIRE,
      pp: 5,
      category: :special,
      power: 130
      )
  end

  def additional_move(pokemon)
    PyroclasticCharge.learn unless pokemon.types.include?(Types::FIRE)
  end
end

class PyroclasticCharge < Move
  include StatChanges

  def self.learn
    new(priority: 6)
  end

  def additional_action(pokemon)
    volatile_status_apply(pokemon, OnFireStatus.get_on_fire(pokemon))
    pokemon.volatile_status[:on_fire].change_pok_type(pokemon)
    stat_changes
  end

  def stat
    [
      [:atk, 2],
      [:def, -2],
      [:sp_atk, 2],
      [:sp_def, -2]
    ]
  end
end