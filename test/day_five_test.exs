defmodule DayFiveTest do
  use ExUnit.Case
  import DayFive

  @docp """
  TDD todo list
  [ ]

  [x] parse lines
  [x] test for diagonal
  [x] filter diagonal lines
  [x] flatten line ends to list of coordinates
  [x] reduce coordinates into map
  [x] count number greater than 1
  """

  test "day 5 part 1 output" do
    "priv/day_five_input.txt"
    |> get_height_over_one_no_diagonal
    |> then(&"height over one for day 5 part 1 #{&1}\n")
    |> IO.puts()
  end

  test "day 5 part 2 output" do
    "priv/day_five_input.txt"
    |> get_height_over_one
    |> then(&"height over one for day 5 part 2 #{&1}\n")
    |> IO.puts()
  end

  test "process test file part 2" do
    assert get_height_over_one("priv/day_five_test_input.txt") == 12
  end

  test "process test file part 1" do
    assert get_height_over_one_no_diagonal("priv/day_five_test_input.txt") == 5
  end

  test "generate coordinates" do
    assert generate_coordinates([[0, 9], [2, 9]]) == [{0, 9}, {1, 9}, {2, 9}]
    assert generate_coordinates([[5, 0], [3, 0]]) == [{5, 0}, {4, 0}, {3, 0}]
  end

  test "generate diagonal coordinates" do
    assert generate_coordinates([[0, 2], [2, 0]]) == [{0, 2}, {1, 1}, {2, 0}]
    assert generate_coordinates([[0, 0], [2, 2]]) == [{0, 0}, {1, 1}, {2, 2}]
    assert generate_coordinates([[2, 2], [0, 0]]) == [{2, 2}, {1, 1}, {0, 0}]
  end

  test "parse line" do
    assert parse_line("0,9 -> 5,9") == [[0, 9], [5, 9]]
  end

  test "diagonal test" do
    refute is_diagonal?([[0, 9], [5, 9]])
    refute is_diagonal?([[0, 1], [0, 9]])
    assert is_diagonal?([[0, 1], [1, 2]])
  end
end
