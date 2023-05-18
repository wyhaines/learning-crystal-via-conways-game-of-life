# Learning Crystal Via Conway's Game of Life

Learning by doing is one of the best ways to learn. This repository is intended to be used as a guided lesson or workshop, with the goal of teaching some of the basics of the Crystal programming language by implementing Conway's Game of Life.

## Installation

To get started with this lesson, [fork](https://github.com/wyhaines/learning-crystal-via-conways-game-of-life/fork) this repository. If you have Crystal installed on your local machine, feel free to use it, but this repository is setup for use with Github Codespaces, which provides a fully configured development environment for you to use.

## What is Conway's Game of Life?

First of all, it isn't a game. It's actually a simulation. It's a simulation of a cellular automaton, which is a system of cells that are governed by a set of rules that determine how the cells change over time. This particular simulation is ran on a grid of arbitrary size, where each cell in the grid has one of two states, alive or dead. The simulation runs in discrete steps, where each step is called a generation. The rules that govern each generation are:

1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
2. Any live cell with two or three live neighbours lives on to the next generation.
3. Any live cell with more than three live neighbours dies, as if by overpopulation.
4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

These rules can be simplified to:

1. Any live cell with two or three live neighbours survives.
2. Any dead cell with three live neighbours becomes a live cell.
3. All other live cells die in the next generation. Similarly, all other dead cells stay dead.

## Structure of this Workshop

This README will walk you through the steps of implementing Conway's Game of Life in Crystal, introducing the concepts necessary for each step along the way. To work your way through the steps, the first thing that you should do is to create a new branch from the `main` branch of your fork of this repository. This will be your working branch. If, at any point, you get stuck, you can save your work to your branch, and switch to the branch for whichever step you are at to see my solution for that step. It won't necessarily match the work that you are doing, but it should give you the clues that you need to get unstuck.

## Step 1: Create your branch

It is a good idea to understand some basic git commands, but if you need a brief summary of the important commands, here they are:

```bash
git checkout -b working-branch
```

This branch will hold your work. When you want to save your work, you can commit it to this branch:

```bash
git commit -a
```

This command will save all of the changes between the last commit and the current state of your working directory. It will open an editor for you to enter a commit message. When you are done, save the file and exit the editor, and the commit will be saved.

Before `git commit` will work, you need to tell git which files you want to commit. You can do this with `git add`:

```bash
git add src/life.cr
```

You won't necessarily need to use this command, though, because for most solutions, all of the files that you need already exist in this repository. You will just need to edit them.

## Step 2: Crystal is Object Oriented

Crystal is an object oriented language. This means that functionality in Crystal programs is usually grouped according to its overall purpose. A class in Crystal is one way of grouping this funcationality together. It creates a recipe, of sorts, for creating objects that that can carry out that functionality, and can contain data that is specific to each object. For example, since the goal is to write an implementation of Conway's Game of Life, we might create a class called `Life` that will contain the functionality for the simulation.

The way to create a class in Crystal is via the `class` keyword:

```crystal
class Life
end
```

This creates a class called `Life`. It doesn't do anything, though. It's just a container. To make it do something, it needs to have methods and probably a way to store data, called instance variables.

Methods in Crystal are created with the `def` keyword:

```crystal
class Life
  def initialize
  end

  def print_board
    print "\e[2J\e[f" # Clear screen
  end

  def set_alive(x, y)
  end
end
```

This will create three methods. The first is a method called `initialize`. In Crystal, the `initialize` method is called when an object is created. The typical use for it is to setup some state that the object needs to have. The `initialize` method is usually not called directly.

The other method is called `print_board`. This version doesn't do anything other than print a sequence of character that, on most terminals, will cause the screen to be cleared.

The third method, `set_alive` takes two arguments, `x` and `y`. Crystal, being a statically typed language, needs to know or figure out the type of data that each variable holds. In many cases, Crystal can figure this out on its own, using something called *type inference*. This just means that the Crystal compiler can look at how something is being used, and in many cases can figure out what type of data it requires based on how it is being used. In this case, there is no type information attached to either the `x` or the `y` argument, but it will work fine, because Crystal will be able to figure out the type of data that each represents, based on how they are used in the program. Still, if you want to be explicit about the types, you can:

```crystal
class Life
  def set_alive(x : Int32, y : Int32)
  end
end
```

To create a new object of the `Life` class, you use the `new` method, and to call a method on an object, you use the `.` operator followed by the name of the method to call. If you want to pass any arguments to the method, place them after the method call, separated by commas. For example:

```crystal
life = Life.new
life.run(100, 40)
```

This code creates a `Life` object, and then it calls the `run` method on that object, passing in two arguments, `100` and `40`. The parentheses around the arguments are optional, so this could could have been written as `life.run 100, 40`, but using them prevents confusion in some cases, so it is generally a good idea to use them.

The other concept that is important to understand is instance variables. Instance variables are variables that are specific to each object. With instance variables, however, the compiler can not know with certainty what type of data they they hold without being told. This can be done by providing a variable declaration, with a type, in the class definition:

```crystal
class Life
  @height : Int32
  @width  : Int32
end
```

This code, by itself, will not work, however, as Crystal also requires that instance variables be initialized, either when they are declared, or in the `initialize` method. There are a few ways that this can look:

```crystal
class Life
  @height : Int32 = 0
  @width  : Int32 = 0
end
```

```crystal
class Life
  @height : Int32
  @width  : Int32

  def initialize(height, width)
    @height = height
    @width  = width
  end
end
```

```crystal
  def initialize(@height : Int32, @width : Int32)
  end
```

That last version is the most concise, and it shows the other method of initializing instance variables. They can be provided as arguments to the `initialize` method, along with their type definition.

Crystal has many different types, including a variety of integer and floating point types that represent numbers of different types and sizes, characters, strings, booleans, and many more. Containers of other types of data, like arrays and hashes, are also available as types. In Crystal, unlike in some other languages like Ruby or Javascript, however, the type of data that an array, for example, holds must also be specified. For an array of integers, it would look like this:

```crystal
class Example
  @my_array_of_numbers : Array(Int32)
end
```

To initialize that array, you would do something like this:

```crystal
class Example
  @my_array_of_numbers : Array(Int32)

  def initialize
    @my_array_of_numbers = Array(Int32).new
    # or
    # @my_array_of_numbers = [] of Int32
  end
end
```

If you want to initialize an array with all of the elements set to a particular value, you can do that, too:

```crystal
class Example
  @my_array_of_numbers : Array(Int32)

  def initialize
    @my_array_of_numbers = Array(Int32).new(10, 0)
  end
end
```

This will create an array with 10 elements, all set to the value `0`.

This initialization syntax can also be done dynamically, using a block to return the value of the element. A block, in Crystal, is just a piece of code that can be passed into a method, and that method can then call that block, passing in any arguments that it needs to. In this case, the block will be called once for each element in the array, and the value that the block returns will be the value of that element:

```crystal
class Example
  @my_array_of_numbers : Array(Int32)

  def initialize
    @my_array_of_numbers = Array(Int32).new(10) { |i| i * 2 }
  end
end
```

This will create an array with 10 elements. The index of each element to be filled is passed into the block as the argument `i`, and the value of the element is the return value of the block. In this case, the value of each element will be twice its index. This is useful to set the initial state of an array of arrays:

```crystal
class Example
  @my_array_of_arrays_of_numbers : Array(Array(Int32))

  def initialize
    @my_array_of_numbers = Array.new(10) { Array(Int32).new(10) { |i| i * 2 }
  end
end
```

This will create an array of 10 arrays, each of which will have 10 elements, with the value of each element being twice its index.

### Let's Write Some Code

Now that you have a basic understanding of some of these concepts, it is time to write some code. If you look in the `src/` directory of your project, you will find a `life.cr` file. Open it in your editor. You will see that it already has a `Life` class defined, but there is nothing else there. Your first task is to add instance an variable for `@board`, which holds an `Array` of `Array` of `Bool` (`Bool` is a boolean type, that holds a value which is either `true` or `false`), defaulting all values to `false`. In addition, instance variables should be added for `@height` and `@width`, which hold the height and width of the board. The `initialize` method should take two arguments, `height` and `width`, and it should set the `@height` and `@width` instance variables to the values of those arguments, as well as assigning a new `Array` of `Array` of `Bool` to the `@board` instance variable.

If you need help, save your work (`git commit -a`), and then switch to the `step-2` branch (`git checkout step-2`). This branch has the code for this step already written. When you are done looking at it, you can switch back to your working branch again to implement your version (`git checkout working-branch`).

## Step 3: Initialize Board State

The first thing that has to happen, before the simulation can run, is that the `Life` object needs to be initialized with a board state. A subset of the cells on the board should be set to `true`, randomly. A number that gives good results is to randomly set about 25% of the cells to `true`, but you can experiment with different values.

Crystal provides a [`Random`](https://crystal-lang.org/api/latest/Random.html) class that can be used to generate random numbers. It offers a number of sophisticated options, including the ability to chose the random number generator algorithm, or to choose a cryptographically secure random number generator, but for the purposes of this exercise, the default is sufficient. The `Random` class has a `#rand` method that can be used to generate a random number. It takes an argument that is the maximum value that the random number can be. For example, to generate a random number between 0 and 9, you would do this:

```crystal
random_number = Random.rand(10)
```

Crystal offers a shortcut for this use of `Random.rand`, though, since it is so common. It defines the `rand` method at the top level, so that one need not always type the `Random.` first:

```crystal
random_number = rand(10)
```

Another thing that you will need to know is how to do something a specific number of times. Crystal offers several different ways to build loops. One of the simplest is to call the `times` method on an integer number. This method takes a block, and just calls the block the number of times that the integer represents, passing the index of the loop into the block as an argument. For example, to print the numbers 0 through 9, you could do this:

```crystal
10.times { |i| puts i }
```

If you don't need that index, you can omit it:

```crystal
10.times { puts "Hello" }
```

This will print *Hello* 10 times.


### Let's Write Some Code

Add a `set_alive` method to your `Life` class that takes an `x` and `y` coordinate, and sets the cell at that coordinate to `true`.

Then add a `setup` method to your `Life` class that will randomly set about 25% of the cells on the board to `true`. In Crystal, if you want to do integer division, you can use `//` to do so. So, to get an integer representing 25% of the cells on the board, you will do this: `(@height * @width) // 4`. Use that to create a loop that will call `set_alive` on a random x and y coordinate on the board, 25% of the time.

Then add a line to your `initialize` method that calls `setup` after it initializes `@board`, `@height`, and `@width`.

## Step 4: Display the Board

Crystal has another common way to loop through elements in a container class like an array. The [`Array`](https://crystal-lang.org/api/latest/Array.html) class defines a `#each` method that takes a block, and calls that block once for each element in the array, passing the element into the block as an argument. It's use looks like this:

```crystal
my_array = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
my_array.each do |element|
  puts element
end
```

This will print each element of the array on its own line. Notice that there is something new in this example. Instead of wrapping the block code in braces (`{}`), it is wrapped in `do` and `end`. Crystal doesn't care whether a block is wrapped in braces or in a `do`/`end` pair, but it is common convention to use braces for single line blocks, and `do`/`end` for multi-line blocks.

Crystal offers a couple of different ways to output text to your terminal. You have already seen both of these, but they are the `puts` and `print` methods. The `puts` method will output a string, and then a newline character, while the `print` method will just output the string. For example:

```crystal
10.times { puts "Hello" }
```

This will print "Hello" on 10 lines, while this:

```crystal
10.times { print "Hello" }
```

will print "Hello" 10 times, all on the same line -- *HelloHelloHelloHelloHelloHelloHelloHelloHelloHello*.

The last thing that you need to know to write a method to display the board is how to control the flow of the program depending on the state of some variable or statement.

The main way of doing this is through the use of an `if` statement. An `if` statement takes an expression, and if that expression evaluates to `true`, it executes the code in the block that follows it. For example:

```crystal
10.times do |i|
  if i.even?
    puts "#{i} is even"
  else
    puts "#{i} is odd"
  end
end
```

This will print the numbers 0 through 9, and for each number, it will print whether the number is even or odd.

### Let's Write Some Code

Create a `print_board` method in your `Life` class that will print the board to the terminal. Make the first line of your method this:

```crystal
print "\e[2J\e[f"
```

This will clear the screen and put the cursor in the top left corner of the terminal. Doing this immediately before drawing the rest of the board will make the board appear to be annimated when generation after generation is displayed.

You can then either use the `@height` and `@width` instance variables to iterate through every position on the board, or use the `each` method on the `@board` array to iterate through each row of the board, and then the `each` method on each row to iterate through each cell in the row. For each cell, if the cell is `true`, *print* 'O', and if it is `false`, *print* '.'. After each row, print a newline character (`puts` alone on a line will do this).

Now add a `run` method to your `Life` class, and just have it call `print_board` for now.

## Step 5: Let's Make It Do Something

You've already written a lot of code, but you have no idea if any of it works. Let's fix that.

You have a `Life` class defined. In order to use it, you need to create an instance of it, which is called an object. You can do that by calling the `new` method on the class. For example:

```crystal
life = Life.new(40, 20)
```

Once that is done, you can call any of the methods, such as the `run` method, that you have defined on it. For example:

```crystal
life.run
```

Crystal is an object oriented language, meaning that the primary approach to writing code with Crystal is to create classes that encapsulate data and behavior, and then to create objects from those classes, and to call methods on those objects. However, Crystal also supports what is known as imperative code. For the purposes of this exercise, this just means code that is not wrapped in a class, but that just executes, one statement after the next.

### Let's Write Some Code

The lines above will create a new `Life` object, and then call the `run` method on it. If you put those lines into your `life.cr` file, at the end, after the last `end` statement, you will be able to run your program. 

To run your program, just type `crystal run --error-trace src/life.cr` in your terminal. If there are no errors in your program, after a moment, during which Crystal is actually compiling your program, you will see the initial, random state of your board appear in your terminal.

If you do have an error in your program, instead of it running, the `--error-trace` argument that was passed into the run command will cause Crystal to print out a detailed trace that shows you both what your error is and where it is. You can use this information to find and fix any errors that you have.

## Step 6: Calculate the Next Generation

Recall the rules that determine the state of a given cell, for each generation:

1. Any live cell with two or three live neighbours survives.
2. Any dead cell with three live neighbours becomes a live cell.
3. All other live cells die in the next generation. Similarly, all other dead cells stay dead.

To visualize the task, imagine that there is a 3 x 3 grid of cells, and the center of that grid is the cell that you are calculating the next generation for. The cells that surround it are its neighbors. For example:

```
. . .
. X .
. . .
```

In this case, the cell marked with an *X* is the cell that you are calculating the next generation for, and the cells marked with a *.* are its neighbors. You need to write code that counts the number of live cells among the neighbors.

The most direct way to do this is, for each cell, to have two loops. One will iterate through the Y coordinates that are -1, 0, and +1 from the Y coordinate of the cell that is being checked, and one that will iterate through the X coordinates that are -1, 0, and +1 from the X coordinate of the cell that is being checked. The cell at Y+0, X+0 is the cell that we are checking, so skip that one. Keep a tally of all of the cells that are alive, and then assert that this cell will be alive if there are either 3 neighbors, or there are two neighbors and the cell being checked is also alive.

There is edge case that must be handled, however. If the cell that is being checked is on the edge of the board, then some of the cells that are being checked will be off of the board. For example, if the cell being checked is at Y=0, X=0, then the cell at Y=-1, X=-1 is off of the board. You can either identify cases where there are illegal coordinates to be checked, and skip them, or, more interestingly, you can use the modulo operator (`%`)to wrap the coordinates around the board.

For example, if the board is 10 cells wide, and the cell being checked is at X=9, Y=9, then the cells at X=10, and the cells at Y=10 are actually at the opposite side of the board, at X=0 and Y=0, respectively. The modulo operator essentially does an integer division of the left hand side by the right hand side, and returns the remainder. So, in this example, `10 % 10` would return 0. This also works with negative numbers, so `-1 % 10` would return 9.

An example:

```crystal
(-1..1).each do |offset_y|
  next if offset_y == 0

  neighbor_y = (cell_y + offset_y) % @width
  # Do something with neighbor_y
end
```

In this example, we create a [`Range`](https://crystal-lang.org/api/latest/Range.html) with that (-1..1), and then iterate through each of the values in that range (-1, 0, 1).

Crystal allows single statement `if` clauses to be placed after the statement that will be executed if the if statement is true, and the `next` keyword skips immediately to the next iteration of a loop, without executing any of the remaining statement in the loop. So in this example, if `offset_y` is *0*, then the `next` statement is executed, skipping the rest of the block.

The assignment to `neighbor_x` adds the cell's Y coordinate with the offset, and applies the modulo operator with the width of the board. This will return the correct Y coordinate for the neighbor, even if the cell being checked is on the edge of the board.

There is one other small, handy feature of Crystal that you will want to use for this step. When you have something, such as an integer, held in a variable, and you want to add something to it, the obvious code for this is:

```crystal
foo = foo + 1
```

That is a little wordy for something that ends up being a pretty frequent pattern, however, so Crystal has a convenient shorthand for this:

```crystal
foo += 1
```

This is the same as the previous example, but it is a little more concise.

### Let's Write Some Code

For this step, you will write two methods. The first will be a method that will calculate the next state for a given cell, `calculate_next_state`. It should accept two arguments, the X coordinate and the Y coordinate of the cell being checked. It should have a counter that is initialized to zero, and then it should use a loop like the one above, with another nested loop that iterates through the X coordinates, skipping only the case where both `offset_x` and `offset_y` are zero. Then, for each cell, add 1 to the counter if the cell is alive. After the loops, return `true` if the counter is 3, or if the counter is 2 and the cell is alive, and `false` otherwise.

Then write another method on `Life`, `calculate_next_generation`. This method should create a new board array, assigning it to a variable named something like `new_board`. It should iterate through each cell on the board, and call `calculate_next_state` for each cell, and then set the state of the corresponding cell in `new_board` to whatever `calculate_next_state` returns. At the end of the method, `@board` should be set to equal `new_board`.

```crystal
@board = new_board
```

Run your code and ensure that it compiles. Then move on to the next step.

## Step 7: Making It Live!

Your implementation of Conway's Game of Life is nearly complete. The only thing left is to modify the `run` method to run through the generations of the simulation, and to display the results of each generation instead of just displaying the starting state.

Recall earlier when loops were introduced, and you were exposed to both `times` and `each` as ways to loop. Crystal has another very simple way to create a loop. This is done with the `loop` keyword, and a block:

```crystal
loop do
  # Do something, over and over again
end
```

The loop operator creates a loop that will run indefinitely, until either the program exits, or the `break` keyword is encountered. The `break` keyword is like the `next` keyword, except that instead of starting a new iteration of the loop, `break` breaks out of the loop entirely, and execution continues with the statement after the loop. The truth is that all of Crystal's more convenient looping constructs can be implemented with `loop` and `break`, but the more convenient constructs are, well, more convenient. Still, `loop` is what you want if you want a loop that will run for an indefinite period of time.

Crystal is a very fast language, and if you were to run a loop that goes through each generation as fast as the language permits, it would not be possible to really perceive the progress of the board. It would be drawn and redrawn faster than your eyes could take in. However, there is a way to slow things down.

```crystal
sleep 0.1
```

The `sleep` method will pause execution of the program for the number of seconds that you pass to it. So, if you pass it `0.1`, it will pause for one tenth of a second.

### Let's Write Some Code

Modify the `run` method to use a `loop`. Inside of the loop, call `print_board`, and then call `calculate_next_generation`. Finally, add a `sleep` call to pause for a short period of time (a tenth of a second works great, but feel free to experiment here).

If you run your code again, and if the compiler finds no errors, you will see your cellular automata simulation running. Congratulations! It is likely that the simulation will eventually reach a point where it is stable, with the board either no longer changing (and perhaps with all of the cells being dead), or perhaps simply flipping between repeated states. When this happens, press *ctrl-c* to stop the program.

## Step 9: Extra Credit

One convenient feature that could be added to the `calculate_next_generation` method is a check to see if the new board is identical to the old board before assigning the new board to `@board`. If it is identical, print a message to that effect, and exit from the program. This won't detect situations where the board gets stuck repeating through a series of states, but it will detect if the board reaches a state where nothing is changing at all. To exit from a program, you just use the `exit` method:

```crystal
  if MY_CONDITION
    puts "The board is stable."
    exit
  end
```

## Contributing

1. Fork it (<https://github.com/your-github-user/life/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Kirk Haines](https://github.com/your-github-user) - creator and maintainer
