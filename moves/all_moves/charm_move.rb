require_relative "../move"

class CharmMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: 'Charm',
      type: Types::FAIRY,
      pp: 20,
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
