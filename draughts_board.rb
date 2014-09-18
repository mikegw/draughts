class DraughtsBoard
  #Setting up the board

  attr_reader :board_size, :piece_count

  def initialize(size = 8, piece_count = 12, reversed = 1)
    @squares = nil
    @board_size = size
    @piece_count = piece_count
    @reversed = reversed
    populate
  end

  def populate
    @squares = []
    @board_size.times do |row_idx|
      if row_idx < (@board_size / 2 - 1)
        @squares << (row_idx % 2 == 0 ? even_row(:red) : odd_row(:red))
      elsif row_idx > (@board_size / 2)
        @squares << (row_idx % 2 == 0 ? even_row(:green) : odd_row(:green))
      else
        @squares << empty_row
      end
    end

    nil
  end

  #REMOVE THIS
  def squares=(custom_sq_setup)
    @squares = custom_sq_setup
  end

  def squares
    @squares
  end


  #Populate methods

  def even_row(color)
    row = []
    (@board_size / 2).times { row += [Piece.new(color), nil] }
    row
  end


  def odd_row(color)
    row = []
    (@board_size / 2).times { row += [nil, Piece.new(color)] }
    row
  end

  def empty_row
    Array.new(@board_size)
  end

  #Methods for during game
  def swap_sides
    @squares.reverse!
    @reversed = 1 - @reversed
  end

  def move_piece(start_sq, end_sq)
    self[end_sq], self[start_sq] = self[start_sq], nil
    self[end_sq].promote if end_sq[0] == 7
  end

  def pieces_same_color?(sq1, sq2)
    self[sq1].color == self[sq2].color
  end

  def each_piece_with_sq(&prc)
    @board_size.times do |row|
      @board_size.times do |col|
        prc.call(@squares[row][col], sq(row, col)) if @squares[row][col]
      end
    end
  end

  def inspect
    render
  end

  def render
    system('clear')
    puts " " + (0..7).to_a.join(" ")
    @squares.reverse.each_with_index do |row, i|
      print (@board_size - i - 1).to_s
      row_strs = row.map{|sq| sq ? sq.to_s : "  "}

      row_strs.each_with_index do |sq_str, j|
        print (((i + j) % 2 == @reversed) ? sq_str.colorize(:background => :light_black) : sq_str)
      end

      puts (@board_size - i - 1).to_s
    end
    puts " " + (0..7).to_a.join(" ")
    "A board!"
  end


  #Basic operations

  def [](pos)
    x, y = pos
    @squares[x][y]
  end

  def []=(pos, new_val)
    x, y = pos
    @squares[x][y] = new_val
  end

end



#Helper Class

class Square < Array
  def +(other)
    #returns a square
    #works for sq + vect or sq + sq
    x,y = other
    sq(self[0] + x, self[1] + y)
  end

  def -(other_sq)
    #returns an array
    x,y = other_sq[0], other_sq[1]
    [self[0] - x, self[1] - y]
  end

  def /(int)
    sq(self[0] / int, self[1] / int)
  end


  def puts
    "sq#{self}"
  end

  def inspect
    "sq#{self}"
  end

end

def sq(x, y)
  Square.new([x, y])
end

