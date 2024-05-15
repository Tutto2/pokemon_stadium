require_relative "../move"

class ShellSmashMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: 'Shell Smash',
      type: Types::NORMAL,
      pp: 15,
      category: :status
      )
  end

  private
  def status_effect(pokemon_target)
    stat_changes
  end

  def stat
    [
      [:atk, 2],
      [:sp_atk, 2],
      [:spd, 2],
      [:def, -1],
      [:sp_def, -1]
    ]
  end
end
