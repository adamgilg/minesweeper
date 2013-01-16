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

#displays board for testing purposes
  # def display_bomb_board
  #   @game_board.each do |row|
  #     row.each do |item|
  #       print "#{item.adj_bombs}|#{item.bomb} "
  #     end
  #     puts ""
  #   end
  #   return nil
  # end

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
          set_adj.call(item, adjacent_item)
        end
      end
    end
  end

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
  attr_accessor :board

  def initialize(size)
    @size = size
    #change this to accept variable board size later
    @board = Board.new(@size)
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
    if @board.game_board[row][column].bomb
      puts "You lose!"
      return true
    else
      return false
    end
  end

  def win?
    #checks to see if all bombs are flagged and no flags on not-bombs
    total_not_bomb = []
    visited_not_bomb = []
    @board.game_board.each do |row|
      row.each do |item|
        total_not_bomb << item if !item.bomb
        visited_not_bomb << item if !item.bomb && item.visited
      end
    end

    if visited_not_bomb.length == total_not_bomb.length
      puts "Congratulations! You win."
      display_game
      return true
    else
      return false
    end
  end

  def display_game
    print "  "
    (0..@size).each {|num| print "  #{num} "}
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
    row_index = move_array[1].to_i
    column_index = move_array[2].to_i

    if move_array[0] == "r"
      reveal(row_index, column_index)
    elsif move_array[0] == "f"
      flag_space(row_index, column_index)
    end
  end

  def reveal(row_index, column_index)
    if @board.game_board[row_index][column_index].flag
      puts "This position is flagged"
      return
    elsif lose?(row_index, column_index)
      @lose_game = true
    else
      check_reveal_move(row_index, column_index)
    end
  end

  def flag_space(row_index, column_index)
    if @board.game_board[row_index][column_index].flag
      puts "Unflagging position #{row_index}, #{column_index}"
      @board.game_board[row_index][column_index].flag = false
    elsif @board.game_board[row_index][column_index].visited
      puts "Can't flag a visited square."
    else
      puts "Adding flag to position #{row_index}, #{column_index}"
      @board.game_board[row_index][column_index].flag = true
    end
  end


  def play
    player = User.new

    keep_playing = true
    while keep_playing
      display_game
      move = player.get_move
      process_user_move(move)
      if win?
        keep_playing = false
      elsif @lose_game
        keep_playing = false
      end
    end

  end

end

class User

  def get_move
    print "Your move please: "
    user_move = gets.chomp.downcase
  end
end

def start
  puts "What size game square would you like?"
  puts "16 or 9"
  print "> "
  game_board_size = gets.chomp.to_i
  game = Game.new(game_board_size)
  game.play
end
















