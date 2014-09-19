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



class IMError < StandardError
end