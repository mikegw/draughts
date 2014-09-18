class Player

  attr_reader :captured_this_turn

  def initialize(color, board)
    @color = color
    @board = board
    @referee = Referee.new(board)
    @captured_this_turn
  end

  def take_turn
    @captured_this_turn = []
    begin
      print "To move:"
      move_start_str = gets.chomp
      unless move_start_str =~ /^[0-9]+,[0-9]+$/
        raise IMError.new('I don\'t under stand your move')
      end

      print "move to:"
      move_end_str = gets.chomp
      unless move_end_str =~ /^[0-9]+,[0-9]+$/
        raise IMError.new('I don\'t under stand your move')
      end

      move_start = sq(*move_start_str.split(",").map(&:to_i))
      move_end = sq(*move_end_str.split(",").map(&:to_i))
      move_result = @referee.check_move(move_start, move_end)
      @board.move_piece(move_start, move_end)
      if move_result == :jumped
        @captured_this_turn << piece_between(move_start, move_end)
        @board.render
        if @referee.jumps_available?
          take_turn
        end
      end
    rescue IMError => e
      puts e
      retry
    end
  end

  def pickup_piece_between(sq1, sq2)
    sq_between = (sq1 + sq2) / 2
    if @board[sq_between]
      captured , @board[sq_between] =  @board[sq_between], 0
      return captured
    else
      raise "confused!"
    end
  end
end



class IMError < StandardError
end