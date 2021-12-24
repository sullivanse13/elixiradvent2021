defmodule DayTen do
  @moduledoc false

  def median_incomplete_score(file_name) do
    file_name
    |> Utilities.parse_file_lines_with(&find_incorrect/1)
    |> Stream.filter(&is_list(&1))
    |> Stream.map(&incomplete_score(&1, 0))
    |> Enum.sort()
    |> then(fn list -> Enum.at(list, div(length(list), 2)) end)
  end

  def incomplete_score([], score), do: score
  def incomplete_score([")" | tl], score), do: incomplete_score(tl, calc(1, score))
  def incomplete_score(["]" | tl], score), do: incomplete_score(tl, calc(2, score))
  def incomplete_score(["}" | tl], score), do: incomplete_score(tl, calc(3, score))
  def incomplete_score([">" | tl], score), do: incomplete_score(tl, calc(4, score))
  defp calc(x, score), do: 5 * score + x

  def score(file_name) do
    file_name
    |> Utilities.parse_file_lines_with(&find_incorrect/1)
    |> Stream.filter(&is_binary(&1))
    |> Stream.map(&score_symbol/1)
    |> Enum.sum()
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
  def process_line([], incomplete), do: incomplete
  def process_line(["(" | tl], closers), do: process_line(tl, [")" | closers])
  def process_line(["{" | tl], closers), do: process_line(tl, ["}" | closers])
  def process_line(["[" | tl], closers), do: process_line(tl, ["]" | closers])
  def process_line(["<" | tl], closers), do: process_line(tl, [">" | closers])
  def process_line([close | tl], [close | close_tail]), do: process_line(tl, close_tail)
  def process_line([close | _tl], _closers), do: close
end
