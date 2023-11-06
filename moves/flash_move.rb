require_relative "move"


class FlashMove < Move
  include StatChanges

  def self.learn
    new(  attack_name: :flash,
          type: Types::NORMAL,
          category: :status
        )
  end

  private
  def status_effect
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:acc, -1]
    ]
  end
end