class Life
  VERSION = "0.1.0"

  @board : Array(Array(Bool))

  def initialize(@width : Int32, @height : Int32)
    @board = Array.new(@height) { Array.new(@width, false) }
    setup
  end

  def set_alive(x, y)
    @board[y][x] = true
  end

  def setup
    ((@height * @width) // 4).times { set_alive rand(@width), rand(@height) }
  end

  def print_board
    print "\e[2J\e[f" # Clear screen
    @board.each do |row|
      row.each do |cell|
        print cell ? 'O' : '.'
      end
      puts
    end
  end

  def run
    print_board
  end

end

# Run it!
life = Life.new(60, 30)
life.run