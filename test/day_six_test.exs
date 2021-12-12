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
  [ ] process actual input for 80 days -> 5934 fishs
  """

  test "day six part one output" do
    "priv/day_six_input.txt"
    |> simulate_fish_population_from_file(80)
    |> then(&"day six part 1 number of fish: #{&1}\n")
    |> IO.puts
  end

  test " process test input for 80 days -> 5934 fish" do
    assert "priv/day_six_test_input.txt" |> simulate_fish_population_from_file(80) == 5934
  end

  test "process test input for 18 days -> 26 fish" do
    assert "priv/day_six_test_input.txt" |> simulate_fish_population_from_file(18) == 26
  end


  test "when 0 -> produce [6,8]" do
    assert cycle([0],[]) == [6,8]
  end
  test "when not zero -> decrement" do
    assert cycle([3],[]) == [2]
  end

  test "run on test list" do
    assert cycle([2,3,2,0,1],[]) == [1,2,1,6,8,0]
  end
end
