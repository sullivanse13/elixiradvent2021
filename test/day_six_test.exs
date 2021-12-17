defmodule DaySixTest do
  use ExUnit.Case
  import DaySix

  @docp """
  TDD todo list
  [ ]

  [x] parse file
  [x] parse line
  [x] process list with countdown
  [x] when 0 -> produce [6,8]
  [x] when not zero -> decrement
  [x] process test input for 18 days -> 26 fish
  [x] process test input for 80 days -> 5934 fish
  [x] process actual input for 80 days -> ? fish

  [x] create buckets of fish by countdown key
  [x] decrement buckets
  [x] decrement zero day buckets
  [x] decrement all buckets
  [x] iterate over buckets for n days
  [x] speed up algorithm

  """

  test "process test input for 18 days -> 26 fish" do
    assert "priv/day_six_test_input.txt" |> simulate_fish_population_from_file(18) == 26
  end
  test " process test input for 80 days -> 5934 fish" do
    assert "priv/day_six_test_input.txt" |> simulate_fish_population_from_file(80) == 5934
  end

  test "decrement all buckets" do
      assert decrement_all_buckets([{4,5},{0,2}]) == [{3,5}, {6,2}, {8,2}]
      assert decrement_all_buckets([{3,5}, {6,2}, {8,2}])
        == [{2,5}, {5,2}, {7,2}]
      assert decrement_all_buckets([{7,5}, {5,2}, {0,3}])
                                                 == [ {4,2}, {6,8}, {8,3}]
  end

  test "turned parse list into bucketss" do
    assert to_buckets([3,4,3,1,2]) == [{1,1},{2,1},{3,2},{4,1}]
  end

  test "decrement buckets" do
    assert decrement({1,1}) == {0,1}
    assert decrement({0,3}) == [{6,3},{8,3}]
  end

  test "day six part two output" do
    "priv/day_six_input.txt"
    |> simulate_fish_population_from_file(256)
    |> then(&"day six part 2 number of fish: #{&1}\n")
    |> IO.puts
  end

  test "day six part one output" do
    "priv/day_six_input.txt"
    |> simulate_fish_population_from_file(80)
    |> then(&"day six part 1 number of fish: #{&1}\n")
    |> IO.puts
  end

  test "process test input for 256 days -> 26984457539 fish" do
    assert "priv/day_six_test_input.txt" |> simulate_fish_population_from_file(256) == 26984457539
  end

end
