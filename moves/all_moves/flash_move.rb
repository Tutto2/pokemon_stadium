require_relative "../move"

class FlashMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: 'Flash',
      type: Types::NORMAL,
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
      [:acc, -1]
    ]
  end
end
