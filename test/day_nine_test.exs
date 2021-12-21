defmodule DayNineTest do
  use ExUnit.Case, async: true
  import DayNine
  import DayNine.Grid
  import TestHelpers

  @docp """
  TDD todo list
  [ ]

  [ ] get coordinates of lowest
  [ ] get neighbor coordinates
  [ ] recurse on coords until hit 9s
  [ ] get basin size from lowest points
  [ ] get three largest basins
  [ ] recursively build basin from lowest
  [ ]
  """

#  test "get low point coordinates from grid" do
#    "priv/day_nine_test_input.txt"
#    |> get_low_point_coordinates
#    |> assert_equals([{1, 0}, {9, 0}, {2, 2}, {6, 4}])
#  end

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

  defp test_grid() do
    """
    012
    345
    678
    """
    |> build_grid
  end

  test "get number and neighbors from grid 0,0" do
    test_grid()
    |> get_number_and_neighbors(0, 0)
    |> assert_equal({0, [1, 3]})
  end

  test "get number and neighbors from grid center" do
    {4, neighbors} =
      test_grid()
      |> get_number_and_neighbors(1, 1)

    assert_content_equal(neighbors, [1, 3, 5, 7])
  end

  test "build grid" do
    input_string = """
    01
    11
    """

    assert build_grid(input_string) == %DayNine.Grid{h: 2, w: 2, grid: {{0, 1}, {1, 1}}}
  end

  # day one
  # [x] parse input
  # [x] build grid (tuple of tuples?)
  # [x] get number and neighbor from grid
  # [x] calculate neighbors simple
  # [x] calculate neighbors edges
  # [x] find all lowest and calculate total risk
end
