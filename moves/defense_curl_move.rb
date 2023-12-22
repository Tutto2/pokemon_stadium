require_relative "move"

class DefenseCurlMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: :defense_curl,
      type: Types::NORMAL,
      pp: 40,
      category: :status
      )
  end

  private
  def status_effect
    stat_changes
    pokemon.defense_curl_power_up
  end

  def stat
    [
      [:def, 1]
    ]
  end
end