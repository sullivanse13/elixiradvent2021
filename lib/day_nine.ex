defmodule DayNine do
  @moduledoc false

  def build_grid(file_name) do
    file_name |> File.read!() |> DayNine.Grid.new()
  end

  def multiply_basins(file_name) do
    grid = file_name |> build_grid()

    grid
    |> DayNine.Grid.get_low_points()
    |> Stream.map(fn low -> build_basin(low, grid, MapSet.new([low])) end)
    |> Stream.map(&MapSet.size/1)
    |> Enum.sort_by(fn x -> -x end)
    |> Enum.take(3)
    |> Enum.product()
  end

  def build_basin({x, y}, grid, basin) do
    basin_neighbors = get_basin_neighbors(grid, x, y, basin)

    basin = add_neighbors_into_basin(basin_neighbors, basin)

    basin_neighbors
    |> Enum.reduce(basin, fn coord, ac -> build_basin(coord, grid, ac) end)
  end

  defp get_basin_neighbors(grid, x, y, basin) do
    grid
    |> DayNine.Grid.get_neighbor_coords_and_values(x, y)
    |> Stream.filter(fn {value, _coord} -> value < 9 end)
    |> Stream.reject(fn {_value, coord} -> MapSet.member?(basin, coord) end)
    |> Stream.map(fn {_value, coord} -> coord end)
  end

  defp add_neighbors_into_basin(basin_neighbors, basin) do
    basin_neighbors |> MapSet.new() |> MapSet.union(basin)
  end

  def calculate_risk_for_low_spots(file_name) do
    grid = file_name |> build_grid()

    grid
    |> DayNine.Grid.get_low_points()
    |> Stream.map(fn low -> DayNine.Grid.get(grid.grid, low) end)
    |> Stream.map(fn n -> n + 1 end)
    |> Enum.sum()
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

    def get_low_points(%__MODULE__{} = grid) do
      grid
      |> DayNine.Grid.coordinates()
      |> Stream.map(&DayNine.Grid.get_cell_and_neighbors(grid, &1))
      |> Stream.filter(&neighbors_are_greater/1)
      |> Stream.map(fn low -> low.coord end)
    end

    defp neighbors_are_greater(%{neighbor_values: neighbors, value: n}) do
      neighbors
      |> Enum.all?(fn neighbor -> neighbor > n end)
    end

    def coordinates(%__MODULE__{h: height, w: width}) do
      for x <- 0..(width - 1), y <- 0..(height - 1), do: {x, y}
    end

    def print(%__MODULE__{grid: grid, h: height, w: width}) do
      IO.puts("height: #{height}, width: #{width}")

      grid
      |> Tuple.to_list()
      |> Stream.map(fn row -> row |> Tuple.to_list() |> Enum.join() end)
      |> Enum.join("\n")
      |> IO.puts()
    end

    def get_cell_and_neighbors(%__MODULE__{grid: grid, h: height, w: width}, {x, y}) do
      neighbor_coord = calculate_neighbors(x, y, height, width)

      neighbor_values = neighbor_coord |> Enum.map(fn coords -> get(grid, coords) end)

      %{
        value: get(grid, x, y),
        neighbor_values: neighbor_values,
        coord: {x, y},
        neighbor_coord: neighbor_coord
      }
    end

    def get_neighbor_coords_and_values(%__MODULE__{grid: grid, h: height, w: width}, x, y) do
      calculate_neighbors(x, y, height, width)
      |> Enum.map(fn coords -> {get(grid, coords), coords} end)
    end

    def calculate_neighbors(x, y, height, width) do
      row_neighbors = build_coords(x, width, fn nx -> {nx, y} end)
      vert_neighbors = build_coords(y, height, fn ny -> {x, ny} end)

      row_neighbors ++ vert_neighbors
    end

    def build_coords(n, max, producer) do
      for nn <- (n - 1)..(n + 1), nn != n and nn >= 0 and nn < max, do: producer.(nn)
    end

    def get(grid, {x, y}), do: get(grid, x, y)
    def get(grid, x, y), do: grid |> elem(y) |> elem(x)

    def coord_set(%__MODULE__{grid: grid}) do
      for x <- 0..(grid.w - 1), y <- 0..(grid.h - 1), do: {x, y}
    end

    defp parse_line(string) do
      string
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end
  end
end
