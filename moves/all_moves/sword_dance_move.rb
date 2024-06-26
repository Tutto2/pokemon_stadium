require_relative "../move"

class SwordsDanceMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: 'Sowrds Dance',
      type: Types::NORMAL,
      pp: 20,
      category: :status
      )
  end

  private
  def status_effect(pokemon_target)
    stat_changes
  end

  def stat
    [
      [:atk, 2]
    ]
  end
end
