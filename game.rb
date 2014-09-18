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
    p ['game_over?', both_players_have_pieces?, both_players_can_move?]
    !(both_players_have_pieces? && both_players_can_move?)
  end

  def both_players_have_pieces?
    @players.all? { |color, player| player_has_pieces?(color) }
  end

  def player_has_pieces?(color)
    @board.each_piece_with_pos do |piece, pos|
      return true if piece.color == color
    end

    false
  end

  def both_players_can_move?
    p ['both_players_can_move', player_can_move?,  other_player_can_move?]
    player_can_move? && other_player_can_move?
  end

  def player_can_move?(switched = nil)
    switch_player if switched
    @board.each_piece_with_sq do |piece, sq|
      return true if piece_can_move?(piece, sq, switched)
    end
    switch_player if switched
    false
  end

  def piece_can_move?(piece, sq, switched)
    piece.moves.each do |move|
      next unless ( piece.color == @current || move_works?(sq, move) )

      switch_player if switched
      return true
    end

    false
  end

  def move_works?(sq, move)
    begin
      @players[@current].referee.check_move(sq, sq + move)
    rescue IMError
      return false
    end
  end


  def other_player_can_move?
    player_can_move?(:switched)
  end

  def player_has_pieces?(color)
    @board.each_piece_with_sq do |piece, sq|
      return true if piece.color == color
    end

    false
  end

  def end_game
  end
end