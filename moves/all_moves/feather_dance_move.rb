require_relative "../move"

class FeatherDanceMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: 'Feather Dance',
      type: Types::FLYING,
      pp: 15,
      category: :status,
      target: 'one_opp'
      )
  end

  private
  def status_effect(pokemon_target)
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:atk, -2]
    ]
  end
end