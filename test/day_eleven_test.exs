defmodule DayElevenTest do
  use ExUnit.Case, async: true
  import DayEleven
  import TestHelpers

  @input "priv/day_eleven_input.txt"
  @test_input "priv/day_eleven_test_input.txt"

  @docp """
  TDD todo list
  [ ]
  [ ]
  """

  test " " do

  end

  test "day eleven part 1" do
    @input
    |> part_1
    |> then(&"Day eleven part 1 output: #{&1}\n")
    |> IO.puts()
  end

  test "test file part 1" do
    assert part_1(@test_input) == :unset
  end

  test "day eleven part 2" do
    @input
    |> part_2
    |> then(&"Day eleven part 2 output: #{&1}\n")
    |> IO.puts()
  end

  test "test file part 2" do
    assert part_2(@test_input) == :unset
  end

end
