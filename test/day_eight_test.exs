defmodule DayEightTest do
  use ExUnit.Case
  import DayEight
  import TestHelpers

  @docp """
  TDD todo list
  [ ]

  [x] parse line
  [x] count strings of length 2,3,4,7 after pipe in line
  """

  test "day eight part one" do
    "priv/day_eight_input.txt"
    |> count_easy_digits_from_file
    |> assert_equal(514)
    |> then(&"day eight part one: #{&1}\n")
    |> IO.puts
  end

  test "day eight part one test file" do
    assert count_easy_digits_from_file("priv/day_eight_test_input.txt") == 26
  end


  test "parse line" do
    assert parse_line("be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe")
      == ["fdgacbe","cefdb","cefbgd","gcbe"]
  end

  test "count strings of length 2,3,4,7" do
    assert count_easy_digit_size(["aa","fdb","fbgd","aaagcbe", "aaaaaa", "aaaaa"]) == 4

  end

end
