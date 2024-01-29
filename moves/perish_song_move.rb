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
    BattleLog.instance.log(MessagesPool.perish_song_apply_msg)
    volatile_status_apply(pokemon_target, PerishSongStatus.perish_song)
    volatile_status_apply(pokemon, PerishSongStatus.perish_song)
  end
end