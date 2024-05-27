require_relative "../move"

class LeafStormMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(
      attack_name: 'Leaf Storm',
      type: Types::GRASS,
      pp: 5,
      category: :special,
      precision: 90,
      power: 130
      )
  end

  private
  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:sp_atk, -2]
    ]
  end
end
