defmodule DayThreeTest do
  use ExUnit.Case
  import DayThree

  @docp """
  TDD todo list
  [ ]

  [x] read list of binaries
  [x] product of gamma and epsilon from file
  [x] find most/least common setting from list if 0,1
  [x] split list of binaries to list of columns
  [x] build gamma and epsilon from least, most common

  [ ] generate life support rating
  pick O2 generator rating
  [x] pick by most common bit in column 0, then 1, then 2
  [x] for O2 if same count use '1'
  pick CO2 scrubber rating
  [x] pick by least common bit in column 1, then 2, then 3
  [x] for CO2 scrubber if same count use '0'


  [x] get most common bit list
  [x] parse string to int and group by column bit
  """

  test "day 3 part 2 output" do
    "priv/day_three_input.txt"
    |> get_life_support_rating
    |> then(fn x -> "Day 3 Life Support Rating #{x}\n" end)
    |> IO.puts()
  end

  test "get test file life support rating" do
    "priv/day_three_test_input.txt"
    |> get_life_support_rating
    |> assert_equals(230)
  end

  test "get co2 scrubber from file" do
    "priv/day_three_test_input.txt"
    |> Utilities.read_file_to_list_of_strings()
    |> binary_strings_to_int
    |> get_co2_scrubber_rating(4)
    |> assert_equals(10)
  end

  test "get oxygen generator from file" do
    "priv/day_three_test_input.txt"
    |> Utilities.read_file_to_list_of_strings()
    |> binary_strings_to_int
    |> get_oxygen_generator_rating(4)
    |> assert_equals(23)
  end

  test "get oxygen generator from" do
    ["11111", "11110", "00000"]
    |> binary_strings_to_int
    |> get_oxygen_generator_rating(4)
    |> assert_equals(31)
  end

  test "string list to int" do
    assert binary_strings_to_int(["100", "11", "0110"]) == [4, 3, 6]
  end

  test "group by column bit" do
    assert group_by_column_bit([16, 24, 26, 14], 4) == [{0, [14]}, {1, [16, 24, 26]}]
    assert group_by_column_bit([16, 14, 1], 4) == [{0, [14, 1]}, {1, [16]}]
    assert group_by_column_bit([1, 3, 4], 0) == [{0, [4]}, {1, [1, 3]}]
  end

  defp assert_equals(actual, expected) do
    assert actual == expected
  end

  test "part 1 output" do
    x = power_consumption_from_file("priv/day_three_input.txt")

    "day three part one power #{x}\n"
    |> IO.puts()
  end

  test "get product from file" do
    assert power_consumption_from_file("priv/day_three_test_input.txt") == 198
  end

  test "build gamma and epsilon from least, most common" do
    assert build_epsilon_gamma([
             [1, 0],
             [0, 1]
           ]) == [2, 1]
  end

  test "reduce column to most/least common" do
    assert get_most_least_common([0, 0, 0, 1, 1]) == [1, 0]
    assert get_most_least_common([0, 0, 1, 1, 1]) == [0, 1]
  end

  test "split list of binaries into columns" do
    assert make_columns(["01", "10", "01", "10"]) == [[0, 1, 0, 1], [1, 0, 1, 0]]
  end
end
