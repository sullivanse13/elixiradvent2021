defmodule Utilities do
  @moduledoc false


  def parse_file_lines_with(file_name, func) do
    file_name
    |> read_file_to_list_of_strings
    |> Stream.map(fn line -> func.(line) end)
  end

  def parse_single_line_to_int_list(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_string_to_int_list/1)
    |> Enum.to_list()
    |> List.flatten()
  end

  def parse_string_to_int_list(string, delimiter \\ ~r/,/) do
    string
    |> String.split(delimiter)
    |> Enum.map(&String.to_integer/1)
  end

  def read_file_to_list_of_strings(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  def read_file_into_groups(file_name) do
    file_name
    |> File.read!()
    |> String.split(~r/\n\n/)
  end


  defp method(day, part) do
    """
    test "day #{day} part #{part}" do
        @input
        |> part_#{part}
        |> then(&"Day #{day} part #{part} output: \#{&1}\\n")
        |> IO.puts()
      end

      test "test file part #{part}" do
        assert part_#{part}(@test_input) == :unset
      end
    """
  end


  def make_day(day) do
    capitalized_day = String.capitalize(day)

    input = "priv/day_#{day}_input.txt"
    test_input = "priv/day_#{day}_test_input.txt"

    input |> File.touch!()
    test_input |> File.touch!()

    day_module = """
    defmodule Day#{capitalized_day} do
      @moduledoc false

      def part_1(file_name) do

      end

      def part_2(file_name) do

      end
    end
    """

    "lib/day_#{day}.ex"
    |> File.write!(day_module)

    test_module = """
    defmodule Day#{capitalized_day}Test do
      use ExUnit.Case, async: true
      import Day#{capitalized_day}
      import TestHelpers

      @input "#{input}"
      @test_input "#{test_input}"

      @docp \"""
      TDD todo list
      [ ]
      [ ]
      \"""

      test " " do

      end

      #{method(day, 1)}
      #{method(day, 2)}
    end
    """

    "test/day_#{day}_test.exs"
    |> File.write!(test_module)

  end
end
