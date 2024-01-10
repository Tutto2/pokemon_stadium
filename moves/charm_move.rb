require_relative "move"

class CharmMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: :charm,
      type: Types::FAIRY,
      pp: 20,
      category: :status,
      target: :pokemon_target
      )
  end

  private
  def status_effect
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:atk, -2]
    ]
  end
end