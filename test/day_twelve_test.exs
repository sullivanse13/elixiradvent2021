defmodule DayTwelveTest do
  use ExUnit.Case, async: true
  import DayTwelve
  import TestHelpers

  @input "priv/day_twelve_input.txt"
  @test_input "priv/day_twelve_test_input.txt"

  @docp """
  TDD todo list
  [ ]
  [x] parse input creating flat map
      every branch is by directional
  [x] route start-end == 1
  [x] route start-A/a-end == 1
  [x] s-a-end, s-b-end == 2 (s-a-e, s-b-e)
  [x] start-a-b-end == 1
  [x] (s-A-e, s-A-c-A-e) == 2
  [ ] test input caves for 10, 19, 226
  """

  test "day twelve part 1" do
    @input
    |> part_1
    |> then(&"Day twelve part 1 output: #{&1}\n")
    |> IO.puts()
  end

  test "test file part med map" do
    assert part_1("priv/day_twelve_test2_input.txt") == 19
  end

  test "test file part bigger map" do
    assert part_1("priv/day_twelve_test3_input.txt") == 226
  end

  test "test file part 1 small map" do
    assert part_1(@test_input) == 10
  end

  test "(s-A-e, s-A-c-A-e) == 2" do
    """
    start-A
    A-end
    A-c
    """
    |> String.split(~r/\n/, trim: true)
    |> parse_lines
    |> count_paths
    |> assert_equal(2)
  end

  test "s-a-b-end == 1" do
    """
    start-a
    a-b
    b-end
    """
    |> String.split(~r/\n/, trim: true)
    |> parse_lines
    |> count_paths
    |> assert_equal(1)
  end

  test "s-a-end, s-b-end == 2" do
    """
    start-a
    start-b
    a-end
    b-end
    """
    |> String.split(~r/\n/, trim: true)
    |> parse_lines
    |> count_paths
    |> assert_equal(2)
  end

  test "simple route 1 count 1 node" do
    """
    start-A
    A-end
    """
    |> String.split(~r/\n/, trim: true)
    |> parse_lines
    |> count_paths
    |> assert_equal(1)
  end

  test "simple route 1 count no nodes" do
    """
    start-end
    """
    |> String.split(~r/\n/, trim: true)
    |> parse_lines
    |> count_paths
    |> assert_equal(1)
  end

  test "parse lines" do
    """
    start-A
    start-b
    A-b
    A-end
    """
    |> String.split(~r/\n/, trim: true)
    |> parse_lines
    |> assert_map_equal(%{
      "A" => ["b", "end"],
      "b" => ["A"],
      "start" => ["A", "b"]
    })
  end

  #
  #  test "test file part 2" do
  #    assert part_2(@test_input) == :unset
  #  end
  #
  #
  #  test "day twelve part 2" do
  #    @input
  #    |> part_2
  #    |> then(&"Day twelve part 2 output: #{&1}\n")
  #    |> IO.puts()
  #  end
end
