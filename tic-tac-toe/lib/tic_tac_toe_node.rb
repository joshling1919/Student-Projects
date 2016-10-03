require_relative 'tic_tac_toe'

class TicTacToeNode

  attr_reader :board, :next_mover_mark, :prev_move_pos
  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    winner = @board.winner
    if @board.over?
      return true if winner != evaluator
      return false if winner == nil || winner == evaluator
    end
    # opponent_mark = evaluator == :x ? :o : :x
    a = children.all? { |child| child.losing_node?(evaluator) }
    b = children.none? { |child| child.winning_node?(evaluator) }
    a || b
  end

  def winning_node?(evaluator)
    winner = @board.winner
    if @board.over?
      return true if winner == evaluator
      return false if winner == nil || winner != evaluator
    end
    # opponent_mark = evaluator == :x ? :o : :x
    a = children.any? { |child| child.winning_node?(evaluator) }
    b = children.none? { |child| child.losing_node?(evaluator) }
    a || b
  end

  def tying_node?
      return true if @board.tied?

  end

  def this_mark
    @next_mover_mark == :x ? :o : :x
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    nodes = []
    @board.rows.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        pos = [row_idx, col_idx]
        next unless @board[pos].nil?
        new_board = @board.dup
        new_board[pos] = @next_mover_mark
        nodes << TicTacToeNode.new(new_board, this_mark, pos)
      end
    end
    nodes
  end
end
