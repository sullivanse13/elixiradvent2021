defmodule DayNineTest do
  use ExUnit.Case, async: true
  import DayNine
  import DayNine.Grid
  import TestHelpers

  @docp """
  TDD todo list
  [ ]

  [x] get coordinates of lowest
  [x] get neighbor coordinates
  [x] build basin from low point
  [x] recurse on coords until hit 9s
  [x] get basin size from lowest points
  [x] get three largest basins
  [x] recursively build basin from lowest
  [ ]
  """

  test "build basin" do
    grid = "priv/day_nine_test_input.txt" |> build_grid()

    {0, 1}
    |> build_basin(grid, MapSet.new([{0, 1}]))
    |> assert_equal(MapSet.new([{0, 0}, {0, 1}, {1, 0}]))

    zero_row = for x <- 9..5, do: {x, 0}

    expected = zero_row ++ [{9, 1}, {8, 1}, {6, 1}, {9, 2}]

    {9, 0}
    |> build_basin(grid, MapSet.new([{9, 0}]))
    |> assert_equal(MapSet.new(expected))
  end

  test "part 2 output" do
    "priv/day_nine_input.txt"
    |> multiply_basins
    |> assert_equals(1_148_965)
    |> then(&"day nine part 2 (3 basin product) #{&1}\n")
    |> IO.puts()
  end

  test "get low point coordinates from grid" do
    "priv/day_nine_test_input.txt"
    |> multiply_basins
    |> assert_equal(1134)
  end

  test "part 1 output" do
    "priv/day_nine_input.txt"
    |> calculate_risk_for_low_spots
    |> assert_equal(417)
    |> then(&"day nine part 1 risk #{&1}\n")
    |> IO.puts()
  end

  test "find lows for test input" do
    "priv/day_nine_test_input.txt"
    |> calculate_risk_for_low_spots
    |> assert_equals(15)
  end

  test "calculate neighbors simple" do
    assert calculate_neighbors(1, 1, 3, 3) == [{0, 1}, {2, 1}, {1, 0}, {1, 2}]
  end

  test "calculate neighbors edge" do
    calculate_neighbors(0, 0, 3, 3)
    |> assert_content_equal([{0, 1}, {1, 0}])

    calculate_neighbors(2, 2, 3, 3)
    |> assert_content_equal([{1, 2}, {2, 1}])
  end

  test "build grid" do
    input_string = """
    01
    11
    """

    assert DayNine.Grid.new(input_string) == %DayNine.Grid{h: 2, w: 2, grid: {{0, 1}, {1, 1}}}
  end

  # day one
  # [x] parse input
  # [x] build grid (tuple of tuples?)
  # [x] get number and neighbor from grid
  # [x] calculate neighbors simple
  # [x] calculate neighbors edges
  # [x] find all lowest and calculate total risk
end
