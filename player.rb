class Player

  attr_reader :captured_this_turn, :referee

  def initialize(color, board)
    @color = color
    @board = board
    @referee = Referee.new(board)
    @captured_this_turn
  end

  def take_turn
    @captured_this_turn = []
    begin
      #get moves
      move_start = get_move_start
      move_end = get_move_end

      #make move if allowed
      move_result = @referee.check_move(move_start, move_end)
      @board.move_piece(move_start, move_end)

      #decide whether to allow player another turn
      if move_result == :jumped
        @captured_this_turn << pickup_piece_between(move_start, move_end)
        #@board.render
        if @referee.piece_can_jump?(move_end)
          return false
        end
      end

    #rety if invalid move error
    rescue IMError => e
      puts e
      retry
    end

    :turn_finished
  end

  def pickup_piece_between(sq1, sq2)
    sq_between = (sq1 + sq2) / 2
    if @board[sq_between]
      captured , @board[sq_between] =  @board[sq_between], nil
      return captured
    else
      raise "confused!"
    end
  end

  def get_move_start
    print "To move:"
    move_start_str = gets.chomp
    unless move_start_str =~ /^[0-9]+,[0-9]+$/
      raise IMError.new('I don\'t under stand your move')
    end

    sq(*move_start_str.split(",").map(&:to_i))
  end

  def get_move_end
    print "move to:"
    move_end_str = gets.chomp
    unless move_end_str =~ /^[0-9]+,[0-9]+$/
      raise IMError.new('I don\'t under stand your move')
    end

    move_end = sq(*move_end_str.split(",").map(&:to_i))
  end
end


class ComputerPlayer < Player
  def look_at_moves(board = @board.dup, first_move = nil, depth = 0)
  end

  def minimax(board = @board.dup, depth = 6, maximizingPlayer, interesting)
    if depth == 0 or board.won? or interesting == false
      return [board.score(@color), move]
    if maximizingPlayer
      bestValue = -100

      each_available_move do |start_sq, end_sq, move_result|
        new_board = board.dup
        new_board.move_piece(start_sq, end_sq)

        if move_result == :jumped
          pickup_piece_between(start_sq, end_sq)
          if @referee.piece_can_jump?(end_sq)
            val, move = minimax(new_board, depth, true, true)
          else
            val, move = minimax(new_board, depth - 1, false, true)
          end
        else
          val, move = minimax(new_board, depth - 1, false, false)
        end

        best_val, best_move = (val > best_val ? val, move : best_val, best_move)
      end
      return [best_val, best_move]
    else
      bestValue = 100
      each_available_move do |start_sq, end_sq, move_result|
        new_board = board.dup
        new_board.move_piece(start_sq, end_sq)

        if move_result == :jumped
          pickup_piece_between(start_sq, end_sq)
          if @referee.piece_can_jump?(end_sq)
            val, move = minimax(new_board, depth, true, true)
          else
            val, move = minimax(new_board, depth - 1, false, true)
          end
        else
          val, move = minimax(new_board, depth - 1, false, false)
        end

        best_val, best_move = (val > best_val ? val, move : best_val, best_move)
      end
      return [best_val, best_move]


  end

  def get_move
    best_move = [[],[]]
    best_score = 0

    # score by how many how many pieces are exchanged
    #look at "interesting" moves in more depth

    #loop through each move on each piece
    #if move is a slide, find best move for opponent and
    #pass their score * -1
  end

  def each_available_move(color, &prc)
    each_piece_with_sq do |piece, sq|
      piece.moves.each do |move|
        begin
          move_result = @referee.check_move(sq, sq + move))
        rescue IMError
          next
        end
        prc.call(start_sq, end_sq, move_result)
      end
    end
  nil
  end



end



class IMError < StandardError
end