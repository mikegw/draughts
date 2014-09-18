require 'colorize.rb'
require 'debugger'

require_relative 'game'
require_relative 'draughts_piece'
require_relative 'player'
require_relative 'referee'
require_relative 'draughts_board'

def crd
  Piece.new(:red)
end

def cgn
  Piece.new(:green)
end


basic_squares = [[nil, crd, nil, crd, nil, crd, nil, crd],
                 [crd, nil, crd, nil, crd, nil, crd, nil],
                 [nil, crd, nil, crd, nil, crd, nil, crd],
                 [nil, nil, nil, nil, nil, nil, nil, nil],
                 [nil, nil, nil, nil, nil, nil, nil, nil],
                 [cgn, nil, cgn, nil, cgn, nil, cgn, nil],
                 [nil, cgn, nil, cgn, nil, cgn, nil, cgn],
                 [cgn, nil, cgn, nil, cgn, nil, cgn, nil]]

debug_squares = [[nil, crd, nil, nil, nil, crd, nil, crd],
                 [crd, nil, crd, nil, crd, nil, crd, nil],
                 [nil, cgn, nil, crd, nil, crd, nil, crd],
                 [cgn, nil, cgn, nil, nil, nil, nil, nil],
                 [nil, cgn, nil, nil, nil, nil, nil, nil],
                 [cgn, nil, cgn, nil, cgn, nil, cgn, nil],
                 [nil, cgn, nil, cgn, nil, cgn, nil, cgn],
                 [cgn, nil, cgn, nil, cgn, nil, cgn, nil]]

test_board = DraughtsBoard.new
test_board.squares = debug_squares

game = Game.new(test_board)
game.play