require_relative "move"

class MetronomeMove < Move
  def self.learn
    new(
      attack_name: :metronome,
      type: Types::NORMAL,
      pp: 10,
      category: :status
      )
  end

  private
  def status_effect
    all_moves = MoveLoader.load_moves
    random_move = all_moves.sample
    @metadata = random_move
    random_move.perform_attack(pokemon, pokemon_target)
  end
end