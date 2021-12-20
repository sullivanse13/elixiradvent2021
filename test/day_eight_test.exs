defmodule DayEightTest do
  use ExUnit.Case
  import DayEight
  import TestHelpers

  @docp """
  TDD todo list
  [ ]

  [x] parse line
  [x] decode line
  [x] figure out top
  [x] figure out bottom
  [x] find zero
  [x] find one
  [x] find two
  [x] find three
  [x] find four
  [x] find five
  [x] find six
  [x] find seven
  [x] find eight
  [x] find nine
  """

  test "day eight part two" do
    "priv/day_eight_input.txt"
    |> sum_codes
    |> assert_equal(1_012_272)
    |> then(&"day eight part two: #{&1}\n")
    |> IO.puts()
  end

  test "day 8 part 2 test file" do
    "priv/day_eight_test_input.txt"
    |> sum_codes
    |> assert_equal(61229)
  end

  test "parse to sorted codes" do
    line = "acedgfb cdfbe | cdfeb fcadb"
    assert parse_sort_line(line) == {["abcdefg", "bcdef"], ["bcdef", "abcdf"]}
  end

  test "decode line one" do
    line = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
    assert decode_line(line) == 5353
  end

  test "decode line two" do
    line =
      "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe"

    assert decode_line(line) == 8394
  end

  @test_row [
    "acedgfb",
    "cdfeb",
    "gcdfa",
    "fbcad",
    "dab",
    "cefabd",
    "cdfgeb",
    "eafb",
    "cagedb",
    "ab"
  ]

  test "find 2" do
    @test_row |> find_two() |> assert_code(2, "gcdfa")
  end

  test "find 5" do
    @test_row |> find_five() |> assert_code(5, "cdfeb")
  end

  test "find 3" do
    @test_row |> find_three() |> assert_code(3, "fbcad")
  end

  test "find zero" do
    @test_row |> find_zero() |> assert_code(0, "cagedb")
  end

  test "find six" do
    @test_row |> find_six() |> assert_code(6, "cdfgeb")
  end

  test "find 9" do
    @test_row |> find_nine() |> assert_code(9, "cefabd")
  end

  test "find easy numbers" do
    @test_row |> find_one() |> assert_code(1, "ab")
    @test_row |> find_four() |> assert_code(4, "eafb")
    @test_row |> find_seven() |> assert_code(7, "dab")
    @test_row |> find_eight() |> assert_code(8, "acedgfb")
  end

  def assert_code(input, number, string) do
    input
    |> assert_map_equal(%{number => string, string => number})
  end

  test "figure out bottom" do
    @test_row
    |> find_bottom()
    |> assert_map_equal(%{"c" => :b, :b => "c"})
  end

  test "figure out top" do
    @test_row
    |> find_top()
    |> assert_map_equal(%{"d" => :t, :t => "d"})
  end

  test "day eight part one" do
    "priv/day_eight_input.txt"
    |> count_easy_digits_from_file
    |> assert_equal(514)
    |> then(&"day eight part one: #{&1}\n")
    |> IO.puts()
  end

  test "day eight part one test file" do
    assert count_easy_digits_from_file("priv/day_eight_test_input.txt") == 26
  end

  test "parse line" do
    assert parse_line(
             "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe"
           ) ==
             ["fdgacbe", "cefdb", "cefbgd", "gcbe"]
  end

  test "count strings of length 2,3,4,7" do
    assert count_easy_digit_size(["aa", "fdb", "fbgd", "aaagcbe", "aaaaaa", "aaaaa"]) == 4
  end

  # day
  # [x] parse line
  # [x] count strings of length 2,3,4,7 after pipe in line
end
