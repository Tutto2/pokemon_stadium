require_relative "move"

class ShellSmashMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: :shell_smash,
      type: Types::NORMAL,
      pp: 15,
      category: :status
      )
  end

  private
  def status_effect
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