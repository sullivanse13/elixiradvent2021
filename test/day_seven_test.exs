defmodule DaySevenTest do
  use ExUnit.Case
  import DaySeven

  @docp """
  TDD todo list
  [ ]

  part 2
  [x] find optimal position
  [x] calculate fuel for optimal position
  [x] calculate fuel used for a move
  """

  @test_crabs [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]

  test "day seven part 2" do
    value = "priv/day_seven_input.txt" |> calculate_fuel_from_file
    assert 95_851_339 == value

    value
    |> then(&"fuel used for day 7 part 2 #{&1}\n")
    |> IO.puts()
  end

  test "pre_calc_fuel_for_distance" do
    assert pre_calc_distance_sums(0, 1) == {0, 1}

    assert pre_calc_distance_sums(0, 4) ==
             {0, 1, 3, 6, 10}

    # 0,1,2,3,4
  end

  test "calc fuel for optimal" do
    assert calculate_minimal_fuel_to_align(@test_crabs) == 168
  end

  test "find optimal position" do
    assert find_optimal_position([1, 1, 1]) == 1
    assert find_optimal_position([3, 1, 2]) == 2
    assert find_optimal_position(@test_crabs) == 5
  end

  test "calculate fuel used complicated" do
    assert calculate_fuel_to_move_all_crabs([1, 5], 3, pre_calc_distance_sums(1, 5)) == 6
    assert calculate_fuel_to_move_all_crabs(@test_crabs, 5, pre_calc_distance_sums(0, 16)) == 168
  end

  #
  #  test "calculate fuel used for move part 2 simple" do
  #    assert calculate_fuel_to_move_all_crabs([1, 3], 2) == 2
  #    assert calculate_fuel_to_move_all_crabs([1, 1, 1], 1) == 0
  #    assert calculate_fuel_to_move_all_crabs([1, 2], 1) == 1
  #  end

  test "day seven part 1" do
    "priv/day_seven_input.txt"
    |> calculate_fuel_from_file_part_one
    |> then(&"fuel used for day 7 part 1 #{&1}\n")
    |> IO.puts()
  end

  test "from file test" do
    assert calculate_fuel_from_file_part_one("priv/day_seven_test_input.txt") == 37
  end

  test "find optimal position part one" do
    assert find_optimal_position_part_one([1, 1, 1]) == 1
    assert find_optimal_position_part_one([3, 1, 2]) == 2
    assert find_optimal_position_part_one(@test_crabs) == 2
  end

  test "calculate minimal move simple" do
    assert calculate_minimal_fuel_to_align_part_one([1, 1, 1]) == 0
    assert calculate_minimal_fuel_to_align_part_one([1, 2]) == 1
    assert calculate_minimal_fuel_to_align_part_one([1, 3]) == 2
  end

  test "calculate minimal test list" do
    assert calculate_minimal_fuel_to_align_part_one(@test_crabs) == 37
  end

  #  part 1
  #  [x] find optimal position sorted
  #  [x] find optimal position unsorted
  #  [x] calculate fuel used for a move
  #  [x] parse crab submarine position input
end
