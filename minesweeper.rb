#require 'debugger'
class Board
  DELTAS = [[1, 1],
  [1, 0],
  [1, -1],
  [-1, 1],
  [-1, 0],
  [-1, -1],
  [0, 1],
  [0, -1]
  ]

  attr_reader :game_board

  def initialize(size)
    @game_board = place_bombs(blank_board(size))
  end


  def blank_board(size)
    empty_board = []
    size.times do |row_index|
      empty_row = []
      size.times { |column_index| empty_row << BoardPosition.new(row_index, column_index) }
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

  def display_bomb_board
    @game_board.each do |row|
      row.each do |item|
        print "#{item.adj_bombs}|#{item.bomb} "
      end
      puts ""
    end
  end

  def adjacents(row, column)
    adjacents = []

    DELTAS.each do |delta|
      new_row = row + delta[0]
      new_column = column + delta[1]
      if (0..@game_board.size - 1).include?(new_row) && (0..@game_board.size - 1).include?(new_column)
        adjacents << @game_board[new_row][new_column]
      end
    end
    adjacents
  end

  def visit_adjacents(&set_adj)
    @game_board.each_with_index do |row, row_index| 
      row.each_with_index do |item, column_index|

        adjacents_array = adjacents(row_index, column_index)
        adjacents_array.each do |adjacent_item|
          #this line will be passed in as a block
          #ask Ned about passing in multiple variables to a block
          #item.adj_bombs += 1 if adjacent_item.bomb == true
          set_adj.call(item, adjacent_item)
        end
      end
    end
  end
          #blocks to be passed in to visit_adjacents
          #{ |item, adjacent_item| item.adj_bombs += 1 if adjacent_item.bomb == true }
          #this one is not finished.
          # { continue going if item.adj_bombs == 0 }

end

class BoardPosition
  attr_accessor :bomb, :visited, :adj_bombs, :flag, :row, :column

  def initialize(row, column, bomb=false, visited=false, adj_bombs=0, flag=false)
    @bomb = bomb
    @visited = visited
    @adj_bombs = adj_bombs
    @flag = flag
    @row = row
    @column = column
  end

end

class Game
  def initialize
    #change this to accept variable board size later
    @board = Board.new(9)
  end

  def check_adjacents_zero(row, column)
    if @board.game_board[row][column].adj_bombs == 0 && @board.game_board[row][column].visited != true
      @board.game_board[row][column].visited = true

      adjacent_array = @board.adjacents(row, column)
      adjacent_array.each { |item| check_adjacents_array(item.row, item.column) }

    else
      @board.game_board[row][column].visited = true
      return
    end
  end



end


















