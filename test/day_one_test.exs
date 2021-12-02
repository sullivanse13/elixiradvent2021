defmodule DayOneTest do
  use ExUnit.Case
  import DayOne

  @docp """
  TDD todo list
  [ ]
  [x] create sliding sum
  [x] count increases from file
  [x] count increases in list of numbers
  """

  test "get output sliding sums" do
    "sliding sum increases = #{count_sliding_sum_increases_from_file("priv/day_one_input.txt")}\n"
    |> IO.puts
  end


  test "get sliding sum increases from file" do
    assert count_sliding_sum_increases_from_file("priv/day_one_test_input.txt") == 5
  end

  test "create sliding sum" do
    assert create_sliding_sum([1,1,1]) == [3]
    assert create_sliding_sum([1,1,1,3]) == [3,5]
  end

  test "get output" do
    "increases = #{count_increasing_from_file("priv/day_one_input.txt")}\n"
    |> IO.puts
  end

  test "count increases from file" do
    assert count_increasing_from_file("priv/day_one_test_input.txt") == 7
  end

  test "count increasing numbers in list of 2" do
    assert count_increasing([1,1]) == 0
    assert count_increasing([1,2]) == 1
  end
  test "count increasing numbers in list of 4" do
    assert count_increasing([1,2,1,3]) == 2
  end
end
