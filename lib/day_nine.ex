defmodule DayNine do
  @moduledoc false

  def build_grid(file_name) do
    file_name |> File.read!() |> DayNine.Grid.new()
  end




  def get_low_point_coordinates(file_name) do
    grid = file_name |> build_grid()

    coords = for x <- 0..(grid.w - 1), y <- 0..(grid.h - 1), do: {x, y}
    low_points = coords
      |> Enum.map(fn {x, y} -> DayNine.Grid.get_cell_and_neighbors(grid.grid, x, y) end)
      |> Enum.filter(&neighbors_are_greater/1)

    low_points
  end



  def build_basin({x,y}, grid, acc) do


#    grid |> DayNine.Grid.print()

    neighbor_coords = DayNine.Grid.calculate_neighbors(x, y, grid.h, grid.w)
    basin_neighbors = neighbor_coords
      |> Enum.map(fn coords -> DayNine.Grid.get(grid.grid, coords) end)
      |> Enum.zip(neighbor_coords)
#      |> IO.inspect
      |> Enum.filter(fn {v, _c} -> v < 9 end)
      |> Enum.reject(fn {_v, coord} -> MapSet.member?(acc, coord) end)
      |> Enum.map(fn {_v, coord} -> coord end)
#      |> IO.inspect



    acc = basin_neighbors |> Enum.reduce(acc, fn coord, ac -> MapSet.put(ac, coord) end)

    basin_neighbors |> Enum.reduce(acc, fn coord, ac -> build_basin(coord, grid, ac) end)



  end

  def calculate_risk_for_low_spots(file_name) do
    grid = file_name |> build_grid()

    coords = for x <- 0..(grid.w - 1), y <- 0..(grid.h - 1), do: {x, y}

    coords
    |> Stream.map(fn {x, y} -> DayNine.Grid.get_number_and_neighbors(grid, x, y) end)
    |> Stream.filter(&neighbors_are_greater/1)
    |> Stream.map(&elem(&1, 0))
    |> Stream.map(fn n -> n + 1 end)
    |> Enum.sum()
  end

  defp neighbors_are_greater(%{neighbor_values: neighbors, value: n}) do
    neighbors_are_greater({n,neighbors})
  end

  defp neighbors_are_greater({n, neighbors}) do
    neighbors
    |> Enum.all?(fn neighbor -> neighbor > n end)
  end

  defmodule Cell do
    defstruct x: 0, y: 0, v: 0

    def new(x,y,v) do
      %__MODULE__{x: x, y: y, v: v}
    end
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

    def print(%__MODULE__{grid: grid, h: height, w: width}) do
      IO.puts("height: #{height}, width: #{width}")
      grid
      |> Tuple.to_list
      |> Enum.map(fn row -> row |> Tuple.to_list |> Enum.join() end)
      |> Enum.join("\n")
      |> IO.puts
    end

    def get_cell_and_neighbors(%__MODULE__{grid: grid, h: height, w: width}, x, y) do

      neighbor_coords = calculate_neighbors(x, y, height, width)

      neighbor_values = neighbor_coords |> Enum.map(fn coords -> get(grid, coords) end)

      %{value: get(grid, x, y), neighbor_values: neighbor_values, coord: {x,y}, neighbor_coord: neighbor_coords}
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
