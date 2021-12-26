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
  [x] find 10s positions
  [ ] flash 10s
  [ ] calculate neighbors 1,1
  [ ] calculate neighbors 0,0
  [ ] calculate neighbors 2,2
  [ ] increment certain elements
  [ ] count flashes in cycle no flash
  [ ] count flashes in cycle one square flash
  [ ] count flashes in cycle one square and one neighbor
  [ ] count flashes in cycle whole board ripple
  [ ] reset 10s to zero
  [ ] keep running total of flashes
  """

  test "step with one flash and one ten" do
    """
    123
    459
    677
    """
    |> new()
    |> step()
    |> assert_equal(
      {%DayEleven.Grid{
         elements: %{
           {0, 0} => 2,
           {1, 0} => 4,
           {2, 0} => 5,
           {0, 1} => 5,
           {1, 1} => 7,
           {2, 1} => 0,
           {0, 2} => 7,
           {1, 2} => 9,
           {2, 2} => 9
         },
         size: 3
       }, 1}
    )
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
      elements: %{{0, 0} => 1, {1, 0} => 2, {0, 1} => 3, {1, 1} => 4},
      size: 2
    })
  end

  test "increment grid" do
    small_test_grid()
    |> step()
    |> assert_equal(
      {%DayEleven.Grid{
         elements: %{{0, 0} => 2, {1, 0} => 3, {0, 1} => 4, {1, 1} => 5},
         size: 2
       }, 0}
    )
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
