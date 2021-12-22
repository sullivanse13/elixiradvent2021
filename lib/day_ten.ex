defmodule DayTen do
  @moduledoc false


  def score(file_name) do
    file_name
    |> Utilities.parse_file_lines_with(&find_incorrect/1)
    |> Stream.reject(&:na==&1)
    |> Stream.map(&score_symbol/1)
    |> Enum.sum
  end

  defp score_symbol(")"), do: 3
  defp score_symbol("]"), do: 57
  defp score_symbol("}"), do: 1197
  defp score_symbol(">"), do: 25137

  def find_incorrect(line) do
    line
    |> String.codepoints()
    |> process_line([])
  end

  def process_line([], []), do: :na
  def process_line([], _incomplete), do: :na
  def process_line(["(" | tl], closers), do: process_line(tl, [")" | closers])
  def process_line(["{" | tl], closers), do: process_line(tl, ["}" | closers])
  def process_line(["[" | tl], closers), do: process_line(tl, ["]" | closers])
  def process_line(["<" | tl], closers), do: process_line(tl, [">" | closers])
  def process_line([close | tl], [close | close_tail]), do: process_line(tl, close_tail)
  def process_line([close | _tl], _closers), do: close

end
