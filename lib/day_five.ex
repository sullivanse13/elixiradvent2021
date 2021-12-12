defmodule DayFive do
  @moduledoc false

  def get_height_over_one(file_name) do
    file_name
    |> parse_file
    |> count_higher_than_one_on_grid
  end

  def get_height_over_one_no_diagonal(file_name) do
    file_name
    |> parse_file
    |> Enum.reject(&is_diagonal?/1)
    |> count_higher_than_one_on_grid
  end

  defp parse_file(file_name) do
    file_name
    |> Utilities.read_file_to_list_of_strings()
    |> Enum.map(&parse_line/1)
  end

  defp count_higher_than_one_on_grid(parsed_lines) do
    parsed_lines
    |> Enum.map(&generate_coordinates/1)
    |> List.flatten()
    |> Enum.reduce(%{}, &increment_on_grid/2)
    |> Map.values()
    |> Enum.filter(&(&1 > 1))
    |> Enum.count()
  end

  defp increment_on_grid(coord, grid) do
    grid
    |> Map.update(coord, 1, &(&1 + 1))
  end

  def parse_line(line_string) do
    line_string
    |> String.split(~r/( -> |,)/)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
  end

  def is_diagonal?([[x, _], [x, _]]), do: false
  def is_diagonal?([[_, y], [_, y]]), do: false
  def is_diagonal?(_), do: true

  def generate_coordinates([[x, y1], [x, y2]]), do: for(y <- y1..y2, do: {x, y})
  def generate_coordinates([[x1, y], [x2, y]]), do: for(x <- x1..x2, do: {x, y})

  def generate_coordinates([[x1, y1], [x2, y2]]) do
    # for i <- 0..x2-x1, do: x1+i
    x = increment(x1, x2)
    # for i <- 0..y2-y1, do: y1+i
    y = increment(y1, y2)
    Enum.zip(x, y)
  end

  defp increment(a, b), do: for(i <- a..b, do: i)
end
