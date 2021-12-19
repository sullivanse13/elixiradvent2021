defmodule DayEight do
  @moduledoc false


  def count_easy_digits_from_file(file_name) do
    file_name
    |> Utilities.parse_file_lines_with(&parse_line/1)
    |> Stream.map(&count_easy_digit_size/1)
    |> Enum.sum
  end


  def parse_line(line) do
    [_,output_digits] = String.split(line, ~r/\|/, trim: true)
    output_digits |> String.split
  end

  def count_easy_digit_size(list) do
    Enum.count(list, fn s -> Enum.member?([2,3,4,7],String.length(s)) end)
  end
end
