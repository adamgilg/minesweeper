class Board
  attr_reader :game_board

  def initialize(size)
    @game_board = place_bombs(blank_board(size))
  end

  def blank_board(size)
    empty_board = []
    size.times do
      empty_row = []
      size.times { empty_row << BoardPosition.new }
      empty_board << empty_row
    end
    empty_board
  end

  def place_bombs(board)
    num_of_bombs(board).times do
      row, column = choose_bomb_location(board)
      while board[row][column].bomb == true
        row, column = choose_bomb_location(board)
      end
      board[row][column].bomb = true
    end
  end

  def num_of_bombs(board)
    if board.size == 9
      return 10
    elsif board.size == 16
      return 40
    end
  end

  def choose_bomb_location(board)
    row = rand(0..board.length - 1)
    column = rand(0..board.length - 1)
    [row, column]
  end

  # def display_bomb_board
  #   @game_board.each do |row|
  #     row.each do |item|
  #       print "#{item.bomb} "
  #     end
  #     puts ""
  #   end
  # end



end

class BoardPosition
  attr_accessor :bomb, :visited, :adj_bombs

  def initialize(bomb=false, visited=false, adj_bombs=0)
    @bomb = bomb
    @visited = visited
    @adj_bombs = adj_bombs
  end

end

class Game


end