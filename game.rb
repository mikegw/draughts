class Game

  attr_reader :board

  def initialize(starting_pos = DraughtsBoard.new)
    @board = starting_pos
    @players = {
      :red => Player.new(:red, @board),
      :green => Player.new(:green, @board)
    }
    @current = :red
    @captured_pieces = {:red => [], :green => []}
  end

  def play
    #start_game

    until game_over?
      @board.render
      @players[@current].take_turn
      @captured_pieces[@current] += @players[@current].captured_this_turn
      switch_player
    end

    end_game
  end


  def switch_player
    @current = ( (@current == :green) ? :red : :green )
    @board.swap_sides
  end

  def start_game
    puts "Draughts!"
  end

  def game_over?
    false
  end

  def end_game
  end
end