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
    @game_board = build_board(size)
  end

  def build_board(size)
    board = place_bombs(blank_board(size))
    visit_adjacents(board) do |item, adjacent_item| 
      item.adj_bombs += 1 if adjacent_item.bomb == true
    end

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
    return nil
  end

  def adjacents(row, column, board)
    adjacents_array = []

    DELTAS.each do |delta|
      new_row = row + delta[0]
      new_column = column + delta[1]
      if (0..board.size - 1).include?(new_row) && (0..board.size - 1).include?(new_column)
        adjacents_array << board[new_row][new_column]
      end
    end
    adjacents_array
  end

  def visit_adjacents(board, &set_adj)
    board.each_with_index do |row, row_index| 
      row.each_with_index do |item, column_index|

        adjacents_array = adjacents(row_index, column_index, board)
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

class Game(size)
  attr_accessor :board

  def initialize
    #change this to accept variable board size later
    @board = Board.new(size)
  end

  def check_reveal_move(row, column)
    current_position = @board.game_board[row][column]

    if current_position.flag
      return
    elsif current_position.adj_bombs == 0 && !current_position.visited
      current_position.visited = true

      adjacent_array = @board.adjacents(row, column, @board.game_board)
      adjacent_array.each { |item| check_adjacents_zero(item.row, item.column) }

    else
      current_position.visited = true
      return
    end
  end

  def lose?(row, column)
    #checks if move is a bomb
    #lose if so
  end

  def win?
    #checks to see if all bombs are flagged and no flags on not-bombs
  end

  def display_game
    print "  "
    (0..8).each {|num| print "  #{num} "}
    puts ""
    row_num = 0

    @board.game_board.each do |row|
      print "#{row_num}: "
      row.each do |item|

        if item.flag == true
          print "|f| "
        elsif item.visited == true
          print "|#{item.adj_bombs}| "
        else
          print "|*| "
        end
      end

      puts ""
      row_num += 1
    end
    return nil
  end

  def process_user_move(move_string)
    move_array = move_string.split
    row_index = move_array[1]
    column_index = move_array[2]

    if move_array[0] == "r"
      #@board.game_board[row_index][column_index].visited 
  end

  def play
    #play this game.
    until check_bomb?
    player = User.new

    player.

  end
end

class User
  def initialize
  end

end

def start
  game = Game.new(9)
  game.play
end
















