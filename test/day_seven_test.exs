defmodule DaySevenTest do
  use ExUnit.Case
  import DaySeven

  @docp """
  TDD todo list
  [ ]

  part 2
  [ ] find optimal position sorted
  [ ] find optimal position unsorted
  [ ] calculate fuel used for a move
  """


  test "calculate fuel used for move part 2" do
    assert calculate_minimal_fuel_to_align([1,1,1]) == 0
    assert calculate_minimal_fuel_to_align([1,2]) == 1
    assert calculate_minimal_fuel_to_align([1,3]) == 3
  end

  test "day seven part 1" do
    "priv/day_seven_input.txt"
    |> calculate_fuel_from_file_part_one
    |> then(&"fueld used for day 7 part 1 #{&1}\n")
    |> IO.puts()
  end


  test "from file test" do
    assert calculate_fuel_from_file_part_one("priv/day_seven_test_input.txt") == 37
  end

  test "find optimal position" do
    assert find_optimal_position_part_one([1,1,1]) == 1
    assert find_optimal_position_part_one([3,1,2]) == 2
    assert find_optimal_position_part_one([16,1,2,0,4,2,7,1,2,14]) == 2
  end

  test "calculate minimal move simple" do
    assert calculate_minimal_fuel_to_align_part_one([1,1,1]) == 0
    assert calculate_minimal_fuel_to_align_part_one([1,2]) == 1
    assert calculate_minimal_fuel_to_align_part_one([1,3]) == 2

  end

  test "calculate minimal test list" do
    assert calculate_minimal_fuel_to_align_part_one([16,1,2,0,4,2,7,1,2,14]) == 37
  end

#  part 1
#  [x] find optimal position sorted
#  [x] find optimal position unsorted
#  [x] calculate fuel used for a move
#  [x] parse crab submarine position input
end
