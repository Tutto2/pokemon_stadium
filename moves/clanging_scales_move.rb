require_relative "move"

class ClangingScalesMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include StatChanges

  def self.learn
    new(
      attack_name: :clanging_scales,
      type: Types::DRAGON,
      pp: 5,
      category: :special,
      power: 110,
      target: 'all_opps'
      )
  end

  private
  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:def, -1]
    ]
  end
end