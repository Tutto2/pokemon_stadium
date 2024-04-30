require_relative "move"

class DracoMeteorMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(
      attack_name: 'Draco Meteor',
      type: Types::DRAGON,
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
