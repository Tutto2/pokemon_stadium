require_relative "../move"

class MakeItRainMove < Move
  include BasicSpecialAtk
  include PostEffect
  include StatChanges

  def self.learn
    new(
      attack_name: 'Make It Rain',
      type: Types::STEEL,
      pp: 5,
      category: :special,
      power: 120,
      target: 'all_opps'
      )
  end

  private
  def post_effect(pokemon)
    stat_changes
  end

  def stat
    [
      [:sp_atk, -1]
    ]
  end
end
