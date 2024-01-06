Dir["./moves/*.rb"].each { |file| require file }

class MoveLoader
  def self.load_moves
    moves = []
    move_classes = ObjectSpace.each_object(Class).select { |klass| klass < Move }
    
    move_classes.each do |move_class|
      next if [Move, FocusPunchMove, StruggleMove, ShellTrapMove].include?(move_class)
      move_instance = move_class.learn
      moves << move_instance
    end

    moves
  end
end