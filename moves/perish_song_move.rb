require_relative "move"

class PerishSongMove < Move
  def self.learn
    new(
      attack_name: :perish_song,
      type: Types::NORMAL,
      pp: 5,
      category: :status
      )
  end

  def status_effect
    puts "All pokemon hearing the song will faint in three turns"
    volatile_status_apply(pokemon_target, PerishSongStatus.perish_song)
    volatile_status_apply(pokemon, PerishSongStatus.perish_song)
  end
end