require_relative "volatile_status"

class PerishSongStatus < VolatileStatus
  def self.perish_song
    new(
      name: :perish_song,
      duration: 4
      )
  end

  def perish_song_effect(pokemon)
    pokemon.hp.decrease(pokemon.hp_total)
    BattleLog.instance.log(MessagesPool.perish_song_effect_msg(pokemon.name))
  end
end