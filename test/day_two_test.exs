defmodule DayTwoTest do
  use ExUnit.Case
  import DayTwo

  @docp """
  TDD todo list
  [ ]
  [x] parse forward
  [x] parse down
  [x] parse up
  [x] process list of commands for final position
  [ ] process list of commands from file for product
  """

  test "produce day one part 1 output" do
    x = read_file_calculate_product_of_position("priv/day_two_input.txt")
    IO.puts("product of moves = #{x}\n")
  end

  test "product from file " do
    assert read_file_calculate_product_of_position("priv/day_two_test_input.txt")
     == 150
  end

  test "process list of commands for final positin" do
    commands = "forward 3,down 5,up 3,forward 3" |> String.split(",")
    assert process_commands(commands) == {6,2}
  end

  test "parse forward" do
    assert parse("forward 5") == {5,0}
  end

  test "parse down" do
    assert parse("down 3") == {0,3}
  end

  test "parse up" do
    assert parse("up 4") == {0,-4}
  end



end
