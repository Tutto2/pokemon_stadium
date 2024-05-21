require_relative "../move"

class MetronomeMove < Move
  def self.learn
    new(
      attack_name: 'Metronome',
      type: Types::NORMAL,
      pp: 10,
      category: :status,
      target: 'one_opp'
      )
  end

  private
  def status_effect(pokemon_target)
    all_moves = MoveFinder.load_moves
    callable_moves = all_moves.reject { |move| move.cant_be_use_by_metronome? }
    random_move = callable_moves.sample
    @metadata = random_move
    random_move.perform_attack(pokemon, [pokemon_target])
  end
end
