defmodule DayThreeTest do
  use ExUnit.Case
  import DayThree

  @docp """
  TDD todo list
  [ ]

  [x] read list of binaries
  [x] product of gamma and epsilon from file
  [x] find most/least common setting from list if 0,1
  [x] split list of binaries to list of columns
  [x] build gamma and epsilon from least, most common

  [ ] generate life support rating
  [ ]
  """

  test "part 1 output" do
    x = power_consumption_from_file("priv/day_three_input.txt")
    "day three part one power #{x}\n"
    |> IO.puts
  end


  test "get product from file" do
    assert power_consumption_from_file("priv/day_three_test_input.txt") == 198
  end

  test "build gamma and epsilon from least, most common" do
    assert build_epsilon_gamma([
             [1,0],
             [0,1]]) == [2,1]
  end

  test "reduce column to most/least common" do
    assert get_most_least_common([0,0,0,1,1]) == [1,0]
    assert get_most_least_common([0,0,1,1,1]) == [0,1]
  end

  test "split list of binaries into columns" do
    assert make_columns(["01","10","01","10"]) == [[0,1,0,1], [1,0,1,0]]
  end

end
