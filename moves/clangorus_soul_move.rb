require_relative "move"

class ClangorusSoulMove < Move
  include StatChanges
  include HasSecondaryEffect
  include HpChange

  def self.learn
    new(
      attack_name: :clangorus_soul,
      type: Types::DRAGON,
      pp: 5,
      category: :status
      )
  end

  private
  def status_effect
    return puts "The attack has failed." if pokemon.hp_value <= (pokemon.hp_total / 3.0)
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
    lose_hp(value)
  end

  def value
    (pokemon.hp_total) * ( 1.0 / 3.0 )
  end
end