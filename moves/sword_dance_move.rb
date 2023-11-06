require_relative "move"


class SwordDanceMove < Move
  include StatChanges

  def self.learn
    new(  attack_name: :sowrd_dance,
          type: Types::NORMAL,
          category: :status
        )
  end

  private
  def status_effect
    stat_changes
  end

  def stat
    [
      [:atk, 2]
    ]
  end
end