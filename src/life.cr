class Life
  VERSION = "0.1.0"

  @board : Array(Array(Bool))

  def initialize(@width : Int32, @height : Int32)
    @board = Array.new(@height) { Array.new(@width, false) }
  end

end
