defmodule DayTenTest do
  use ExUnit.Case, async: true
  import DayTen
  import TestHelpers

  @docp """
  TDD todo list
  [ ]
  [x] parse lines
  [x] parse uncorrupted line
  [x] find first incorrect closing character
  [ ] score incorrect characters
  """

  test "day 10 part one" do
    "priv/day_ten_input.txt"
    |> score
    |> then(&"Day 10 part 1 output: #{&1}\n")
    |> IO.puts
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
end
