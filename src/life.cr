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

  def calculate_next_state(x, y)
    alive_neighbours = 0

    (-1..1).each do |offset_y|
      (-1..1).each do |offset_x|
        next if offset_y == 0 && offset_x == 0

        neighbor_x = (x + offset_x) % @width
        neighbor_y = (y + offset_y) % @height

        alive_neighbours += 1 if @board[neighbor_y][neighbor_x]
      end
    end

    alive_neighbours == 3 || (alive_neighbours == 2 && @board[y][x])
  end

  def calculate_next_generation()
    new_board = Array.new(@height) { Array.new(@width, false) }

    @height.times do |y|
      @width.times do |x|
        new_board[y][x] = calculate_next_state(x, y)
      end
    end

    @board = new_board
  end

  def run
    print_board
  end

end

# Run it!
life = Life.new(60, 30)
life.run