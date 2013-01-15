class Board
  attr_reader :game_board

  def initialize(size)
    @game_board = place_bombs(blank_board(size))
  end

  def blank_board(size)
    empty_board = []
    size.times do
      empty_row = []
      size.times { empty_row << " " }
      empty_board << empty_row
    end
    p empty_board
  end

  def place_bombs(board)
    num_of_bombs(board).times do
      row, column = choose_bomb_location(board)
      while board[row][column] == "B"
        row, column = choose_bomb_location(board)
      end
      board[row][column] = "B"
    end
    board
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
end

class BoardPosition
  attr_accessor :bomb, :visited, :adj_bombs

  def initialize(bomb='', visited=false, adj_bombs=0)
    @bomb = bomb
    @visited = visited
    @adj_bombs = adj_bombs
  end


  end

end

class Game


end