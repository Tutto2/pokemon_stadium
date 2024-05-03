require_relative "move"

class DefenseCurlMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: 'Defense Curl',
      type: Types::NORMAL,
      pp: 40,
      category: :status
      )
  end

  private
  def status_effect(pokemon_target)
    stat_changes
    pokemon.defense_curl_power_up
  end

  def stat
    [
      [:def, 1]
    ]
  end
end
