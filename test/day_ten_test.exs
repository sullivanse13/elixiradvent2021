defmodule DayTenTest do
  use ExUnit.Case, async: true
  import DayTen
  import TestHelpers

  @docp """
  TDD todo list
  [ ]

  [ ] find median score from file
  [x] figure out symbols to close incomplete lines
  [x] score missing symbols list
  """

  test "find median score from test file" do
    assert median_incomplete_score("priv/day_ten_test_input.txt") == 288_957
  end

  test "day 10 part 2" do
    "priv/day_ten_input.txt"
    |> median_incomplete_score
    |> then(&"Day 10 part 2 output: #{&1}\n")
    |> IO.puts()
  end

  test "calc incomplete score" do
    assert incomplete_score([")"], 0) == 1
    assert incomplete_score(["]"], 0) == 2
    assert incomplete_score(["}"], 2) == 13
    assert incomplete_score([">"], 0) == 4
    assert incomplete_score([">"], 1) == 9
  end

  test "find incomplete symbol" do
    assert find_incorrect("({}") == [")"]
    assert find_incorrect("({<>") == ["}", ")"]
    assert find_incorrect("[({(<(())[]>[[{[]{<()<>>") == String.codepoints("}}]])})]")
    assert find_incorrect("[({(<(())[]>[[{[]{<()<>>") == String.codepoints("}}]])})]")
  end

  test "day 10 part one" do
    "priv/day_ten_input.txt"
    |> score
    |> then(&"Day 10 part 1 output: #{&1}\n")
    |> IO.puts()
  end

  test "score test file" do
    assert score("priv/day_ten_test_input.txt") == 26397
  end

  test "uncorrupted simple" do
    assert find_incorrect("()") == :na
    assert find_incorrect("[]") == :na
    assert find_incorrect("{}") == :na
    assert find_incorrect("<>") == :na
  end

  test "uncorrupted line embedded" do
    assert find_incorrect("([])") == :na
    assert find_incorrect("(((((((((())))))))))") == :na
    assert find_incorrect("{()()()}") == :na
    assert find_incorrect("[<>({}){}[([])<>]]") == :na
  end

  test "find incorrect closing character for each symbol" do
    assert find_incorrect("(]") == "]"
    assert find_incorrect("{([(<{}[<>[]}>{[]{[(<()>") == "}"
    assert find_incorrect("[[<[([]))<([[{}[[()]]]") == ")"
  end

  #  part 1
  #  [x] parse lines
  #  [x] parse uncorrupted line
  #  [x] find first incorrect closing character
  #  [x] score incorrect characters in file
end
