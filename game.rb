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
      render
      @players[@current].take_turn
      @captured_pieces[@current] += @players[@current].captured_this_turn
      switch_player
    end

    end_game
  end

  def render
    system('clear')
    puts " " + @captured_pieces[other_player].map(&:to_s).join
    @board.render
    puts " " + @captured_pieces[@current].map(&:to_s).join
  end


  def switch_player
    @current = other_player
    @board.swap_sides
  end

  def other_player
    (@current == :green) ? :red : :green
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