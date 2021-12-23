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
  [ ] calculate neighbors of 10s positions
  [ ] increment neighbors
  [ ] find new 10s
  [ ] when no new 10s collect count of flashes
  [ ] reset 10s to zero
  [ ] keep running total of flashes
  """

  defp ten_grid() do
    """
    123
    395
    698
    """
    |> new()
    |> increment_elements([{1,1},{1,2}])
  end

  test "find 10 coordinates" do
    ten_grid()
    |> find_tens()
    |> assert_content_equal([{1,1},{1,2}])
  end


  defp small_test_grid() do
    """
    12
    34
    """
    |> new()
  end

  test "build grid" do
    small_test_grid()
    |> assert_equal(%DayEleven.Grid{elements: [[1,2],[3,4]], h: 2, w: 2})
  end

  test "increment grid" do
    small_test_grid()
    |> tick()
    |> assert_equal(%DayEleven.Grid{elements: [[2,3],[4,5]], h: 2, w: 2})
  end

  test "increment certain elements in a row" do
    small_test_grid()
    |> increment_elements([{0,0},{1,1}])
    |> assert_map_equal(%DayEleven.Grid{elements: [[2,2],[3,5]], h: 2, w: 2})
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