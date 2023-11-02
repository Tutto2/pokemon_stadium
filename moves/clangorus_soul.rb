require_relative "moves"
require_relative "concerns/move_modifiers"

class ClangorusSoulMove < Move
  include StatChanges
  include HasSecondaryEffect
  include HpChange

  def self.learn
    new(  attack_name: :clangorus_soul,
          type: Types::DRAGON,
          category: :status
        )
  end

  private
  def status_effect
    return if pokemon.hp_value <= (pokemon.hp_total / 3.0)
    stat_changes
  end

  def stat
    [
      [:atk, 1],
      [:def, 1],
      [:sp_atk, 1],
      [:sp_def, 1],
      [:spd, 1]
    ]
  end

  def secondary_effect
    lose_hp
  end

  def value
    (pokemon.hp_total) * ( 1.0 / 3.0 )
  end
end