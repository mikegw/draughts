require 'colorize.rb'

require_relative 'game'
require_relative 'draughts_piece'
require_relative 'player'
require_relative 'referee'
require_relative 'draughts_board'

game = Game.new
#p game.board
game.play