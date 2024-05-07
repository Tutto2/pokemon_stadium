require_relative "../move"

class PerishSongMove < Move
  def self.learn
    new(
      attack_name: 'Perish Song',
      type: Types::NORMAL,
      pp: 5,
      category: :status,
      target: 'one_opp'
      )
  end

  def status_effect(pokemon_target)
    BattleLog.instance.log(MessagesPool.perish_song_apply_msg)
    volatile_status_apply(pokemon_target, PerishSongStatus.perish_song)
    volatile_status_apply(pokemon, PerishSongStatus.perish_song)
  end
end
