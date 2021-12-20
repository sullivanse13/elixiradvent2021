defmodule DayNine do
  @moduledoc false

  def build_grid(string) do
    string
    |> DayNine.Grid.new()
  end

  def find_low_spots_heights(file_name) do
    grid = file_name |> File.read!() |> DayNine.Grid.new()

    coords = for x <- 0..(grid.w - 1), y <- 0..(grid.h - 1), do: {x, y}

    coords
    |> Stream.map(fn {x, y} -> DayNine.Grid.get_number_and_neighbors(grid, x, y) end)
    |> Stream.filter(&neighbors_are_greater/1)
    |> Stream.map(&elem(&1, 0))
    |> Stream.map(fn n -> n + 1 end)
    |> Enum.sum()
  end

  defp neighbors_are_greater({n, neighbors}) do
    neighbors
    |> Enum.all?(fn neighbor -> neighbor > n end)
  end

  defmodule Grid do
    defstruct h: 0, w: 0, grid: {}

    def new(string) do
      grid =
        string
        |> String.split(~r/\n/, trim: true)
        |> Enum.map(&parse_line/1)
        |> List.to_tuple()

      %__MODULE__{grid: grid, h: tuple_size(grid), w: tuple_size(elem(grid, 0))}
    end

    def get_number_and_neighbors(%__MODULE__{grid: grid, h: height, w: width}, x, y) do
      neighbors =
        calculate_neighbors(x, y, height, width)
        |> Enum.map(fn coords -> get(grid, coords) end)

      {get(grid, x, y), neighbors}
    end

    def calculate_neighbors(x, y, height, width) do
      row_neighbors = for nx <- (x - 1)..(x + 1), nx != x and nx >= 0 and nx < width, do: {nx, y}

      vert_neighbors =
        for ny <- (y - 1)..(y + 1), ny != y and ny >= 0 and ny < height, do: {x, ny}

      row_neighbors ++ vert_neighbors
    end

    defp get(grid, {x, y}), do: get(grid, x, y)
    defp get(grid, x, y), do: grid |> elem(y) |> elem(x)

    defp parse_line(string) do
      string
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end
  end
end
