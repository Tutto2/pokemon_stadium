require_relative "volatile_status"

class PerishSongStatus < VolatileConditions
  def self.perish_song
    new(
      name: :perish_song,
      duration: 4
      )
  end

  def perish_song_effect(pokemon)
    pokemon.hp.decrease(pokemon.hp_total)
    puts "#{pokemon.name} has lost all its HP due to Perish Song"
  end
end