class Piece

  MAN_REPS = {red: "\u{26AA} ", green: "\u{26AB} "}
  KING_REPS = {red: "\u{24C0} ", green: "\u{1F15A} "}

  STANDARD_DIRS = [[1, 1], [1, -1]]

  KING_DIRS = [[-1, 1], [-1, -1]]

  attr_reader :color

  def initialize(color)
    @color = color
    @king = false
  end

  def promote
    @king = true
  end

  def promoted?
    @king
  end

  def slides
    STANDARD_DIRS + ( promoted? ? KING_DIRS : [] )
  end

  def jumps
    slides.map{|x,y| [2 * x, 2 * y]}
  end

  def moves
    slides + jumps
  end

  def to_s
    @king ? KING_REPS[self.color] : MAN_REPS[self.color]
  end


end

