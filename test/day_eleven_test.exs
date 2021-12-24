defmodule DayElevenTest do
  use ExUnit.Case, async: true
  import DayEleven
  import DayEleven.Grid
  import TestHelpers

  @input "priv/day_eleven_input.txt"
  @test_input "priv/day_eleven_test_input.txt"

  @docp """
  TDD todo list
  [ ]
  [x] build grid
  [x] increment all elements
  [x] increment certain elements
  [x] find 10s positions
  [x] calculate neighbors 1,1
  [x] calculate neighbors 0,0
  [x] calculate neighbors 2,2
  [x] count flashes in cycle no flash
  [x] count flashes in cycle one square flash
  [ ] count flashes in cycle one square and one neighbor
  [ ] count flashes in cycle whole board ripple
  [ ] reset 10s to zero
  [ ] keep running total of flashes
  """

#  test "count flashes in cycle one square and one neighbor" do
#    {grid, count} =
#      [[1, 2, 3], [4, 9, 5], [6, 6, 8]]
#      |> new()
#      |> cycle_and_count_flashes()
#
#    assert count == 2
#
#    assert to_lists(grid) == [
#             [3, 4, 5],
#             [6, 0, 8],
#             [8, 9, 0]
#           ]
#  end

  test " count flashes in cycle no flash" do
    {grid, count} =
      [[1, 2, 3], [4, 9, 5], [6, 7, 7]]
      |> new()
      |> cycle_and_count_flashes()

    assert count == 1

    assert to_lists(grid) == [
             [3, 4, 5],
             [6, 0, 7],
             [8, 9, 9]
           ]
  end

  test "count flashes in cycle no flash" do
    {grid, count} =
      [[1, 2, 3], [4, 5, 6], [7, 8, 0]]
      |> new()
      |> cycle_and_count_flashes()

    assert count == 0

    assert to_lists(grid) == [
             [2, 3, 4],
             [5, 6, 7],
             [8, 9, 1]
           ]
  end

  test "calculate neighbors 1,1" do
    ten_grid()
    |> neighbors({1, 1})
    |> assert_content_equal([
      {0, 0},
      {1, 0},
      {2, 0},
      {0, 1},
      {2, 1},
      {0, 2},
      {1, 2},
      {2, 2}
    ])
  end

  test "calculate neighbors 0,0" do
    ten_grid()
    |> neighbors({0, 0})
    |> assert_content_equal([
      {1, 0},
      {0, 1},
      {1, 1}
    ])
  end

  test "calculate neighbors 2,2" do
    ten_grid()
    |> neighbors({2, 2})
    |> assert_content_equal([
      {1, 2},
      {2, 1},
      {1, 1}
    ])
  end

  defp ten_grid() do
    [[1, 2, 3], [3, 10, 5], [6, 10, 8]]
    |> new()
  end

  test "find 10 coordinates" do
    ten_grid()
    |> find_tens_coords()
    |> assert_content_equal([{1, 1}, {1, 2}])
  end

  defp small_test_grid() do
    """
    12
    34
    """
    |> new()
  end

  test "build grid from strings" do
    small_test_grid()
    |> assert_equal(%DayEleven.Grid{
      elements: %{0 => %{0 => 1, 1 => 2}, 1 => %{0 => 3, 1 => 4}},
      h: 2,
      w: 2
    })
  end

  test "build grid from lists" do
    [[1, 2], [3, 4]]
    |> new()
    |> assert_equal(%DayEleven.Grid{
      elements: %{0 => %{0 => 1, 1 => 2}, 1 => %{0 => 3, 1 => 4}},
      h: 2,
      w: 2
    })
  end

  test "increment grid" do
    small_test_grid()
    |> tick()
    |> assert_equal(%DayEleven.Grid{
      elements: %{0 => %{0 => 2, 1 => 3}, 1 => %{0 => 4, 1 => 5}},
      h: 2,
      w: 2
    })
  end

  test "increment certain elements in a row" do
    small_test_grid()
    |> increment_elements([{0, 0}, {1, 1}])
    |> assert_map_equal(%DayEleven.Grid{
      elements: %{0 => %{0 => 2, 1 => 2}, 1 => %{0 => 3, 1 => 5}},
      h: 2,
      w: 2
    })
  end

  #  test "day eleven part 1" do
  #    @input
  #    |> part_1
  #    |> then(&"Day eleven part 1 output: #{&1}\n")
  #    |> IO.puts()
  #  end
  #
  #  test "test file part 1" do
  #    assert part_1(@test_input) == :unset
  #  end
  #
  #  test "day eleven part 2" do
  #    @input
  #    |> part_2
  #    |> then(&"Day eleven part 2 output: #{&1}\n")
  #    |> IO.puts()
  #  end
  #
  #  test "test file part 2" do
  #    assert part_2(@test_input) == :unset
  #  end
end
