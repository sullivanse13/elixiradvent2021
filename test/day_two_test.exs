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
  [x] process list of commands from file for product
  [x] move using aim no change
  [x] set aim
  [x] move up using aim
  [x] move down using aim
  [x] test series of commands
  [x] output part 2
  """

  test "part 2 output" do
    results = "priv/day_two_input.txt" |> process_commands_with_aim()
    assert results == 1_956_047_400
    IO.puts("product of moves with aim = #{results}\n")
  end

  test "process list of commands" do
    results =
      "priv/day_two_test_input.txt"
      |> process_commands_with_aim()

    assert results == 900
  end

  test "move with aim down set" do
    assert move({8, 0}, {5, 0, 5}) == {13, 40, 5}
  end

  test "move with aim aim up set" do
    assert move({2, 0}, {0, 0, -1}) == {2, -2, -1}
  end

  test "set aim" do
    assert move({0, 3}, {3, 0, 0}) == {3, 0, 3}
  end

  test "move no aim" do
    assert move({5, 0}, {3, 0, 0}) == {8, 0, 0}
  end

  test "produce day one part 1 output" do
    x = read_file_calculate_product_of_position("priv/day_two_input.txt")
    assert x == 1_654_760
    IO.puts("product of moves = #{x}\n")
  end

  test "product from file " do
    assert read_file_calculate_product_of_position("priv/day_two_test_input.txt") ==
             150
  end

  test "process list of commands for final positin" do
    commands = "forward 3,down 5,up 3,forward 3" |> String.split(",")
    assert process_commands_incremental(commands) == {6, 2}
  end

  test "parse forward" do
    assert parse("forward 5") == {5, 0}
  end

  test "parse down" do
    assert parse("down 3") == {0, 3}
  end

  test "parse up" do
    assert parse("up 4") == {0, -4}
  end
end
