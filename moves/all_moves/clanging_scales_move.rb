require_relative "../move"

class ClangingScalesMove < Move
  include BasicSpecialAtk
  include PostEffect
  include StatChanges

  def self.learn
    new(
      attack_name: 'Clanging Scales',
      type: Types::DRAGON,
      pp: 5,
      category: :special,
      power: 110,
      target: 'all_opps'
      )
  end

  private
  def post_effect(pokemon)
    stat_changes
  end

  def stat
    [
      [:def, -1]
    ]
  end
end
