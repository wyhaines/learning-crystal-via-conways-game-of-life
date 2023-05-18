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

end
