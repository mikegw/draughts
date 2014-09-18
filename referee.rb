class Referee

  def initialize(board)
    #@game = game
    @board = board
  end
  #tests all the moves, raises errors if invalid

  def check_move(start_sq, end_sq, option = :standard)
    move = (end_sq - start_sq)

    preflight_checks(start_sq, end_sq, move)

    if move_is_jump?(move)
      jump_sq = start_sq + move_dir(move)
      check_jumping_over_piece(jump_sq)
      check_piece_is_opposing_color(jump_sq, start_sq)

      return :jumped
    else
      # no mandatory jumps
      return :end_turn if option == :quick

      #only want to get here if we're looking for whether the player
      #can make the move...

      raise IMError.new("Should have jumped!") if jumps_available?
      return :end_turn
    end
  end

  #Check methods
  def preflight_checks(start_sq, end_sq, move)
    check_squares_valid(start_sq, end_sq)
    check_piece_in_start_sq(start_sq)
    check_piece_can_make_move(start_sq, end_sq, move)
    check_end_sq_empty(end_sq)
  end

  def check_squares_valid(start_sq, end_sq)
    unless valid_sq?(start_sq) &&  valid_sq?(end_sq)
      raise IMError.new("No such square!")
    end
  end

  def check_piece_in_start_sq(start_sq)
    raise IMError.new("There's no piece there!") unless @board[start_sq]
  end

  def check_piece_can_make_move(start_sq, end_sq, move)
    piece_slides = @board[start_sq].slides
    piece_jumps = @board[start_sq].jumps

    unless (piece_slides.include?(move) || piece_jumps.include?(move))
      raise IMError.new('Piece can\'t move there!')
    end
  end

  def check_end_sq_empty(end_sq)
    unless @board[end_sq].nil?
      raise IMError.new("There's already a piece there!")
    end
  end

  #Jumping check methods

  def check_jumping_over_piece(jump_sq)
    #jumping over piece
    if @board[jump_sq].nil?
      raise IMError.new("No piece to jump over!")
    end
  end

  def check_piece_is_opposing_color(jump_sq, start_sq)
    if @board.pieces_same_color?(jump_sq, start_sq)
      raise IMError.new("Can't jump over your own piece!")
    end
  end

  #Helper methods
  def move_dir(move)
    move.map{|num| num <=> 0}
  end

  def move_is_jump?(move)
    move != move_dir(move)
  end

  def jumps_available?
    @board.each_piece_with_sq do |piece, sq|
      piece.jumps.each do |jump|
        begin
          check_move(sq, sq + jump)
        rescue IMError
          next
        end
        return true
      end
    end

    false
  end

  def valid_sq?(sq)
    sq[0].between?(0, @board.board_size - 1) && sq[0].between?(0, @board.board_size - 1)
  end

end
