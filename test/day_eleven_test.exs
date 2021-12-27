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
  [x] flash 10s
  [x] calculate neighbors 1,1
  [x] calculate neighbors 0,0
  [x] calculate neighbors 2,2
  [x] increment neighbors of flash
  [x] count flashes in step no flash
  [x] count flashes in step one flash
  [x] count flashes in step one flash on 10, causing neighbor to flash
  [x] count flashes in step whole board ripple flashed
  [x] reset 10s to zero
  [x] keep running total of flashes for multiple steps
  [ ] run part_1 test input
  """
  test "test file part 1" do
    assert part_1(@test_input) == 1656
  end


    test "day eleven part 1" do
      @input
      |> part_1
      |> then(&"Day eleven part 1 output: #{&1}\n")
      |> IO.puts()
    end



  test "count flashes in step whole board ripple flashed" do
    """
    888
    818
    889
    """
    |> new()
    |> step()
    |> assert_equal(
         {%DayEleven.Grid{
           elements: %{
             {0, 0} => 0,
             {1, 0} => 0,
             {2, 0} => 0,
             {0, 1} => 0,
             {1, 1} => 0,
             {2, 1} => 0,
             {0, 2} => 0,
             {1, 2} => 0,
             {2, 2} => 0
           },
           size: 3
         }, 9}
       )
  end


  test "count flashes in step one flash on 10, causing neighbor to flash" do
    """
    123
    459
    668
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
           {1, 1} => 8,
           {2, 1} => 0,
           {0, 2} => 7,
           {1, 2} => 9,
           {2, 2} => 0
         },
         size: 3
       }, 2}
    )
  end

  test "count flashes in step one square flash" do
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

  test "step grid" do
    small_test_grid()
    |> step()
    |> assert_equal(
      {%DayEleven.Grid{
         elements: %{{0, 0} => 2, {1, 0} => 3, {0, 1} => 4, {1, 1} => 5},
         size: 2
       }, 0}
    )
  end


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
