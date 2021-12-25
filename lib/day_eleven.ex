defmodule DayEleven do
  @moduledoc false

  def part_1(_file_name) do
  end

  def part_2(_file_name) do
  end

  defmodule Grid do
    defstruct h: 0, w: 0, elements: %{}

    def new(lists) when is_list(lists) do
      h = length(lists)
      w = length(hd(lists))

      lists
      |> Enum.map(&into_index_map/1)
      |> into_index_map
      |> then(&%__MODULE__{elements: &1, h: h, w: w})
    end

    def new(string) do
      grid =
        string
        |> String.split(~r/\n/, trim: true)
        |> Enum.map(&parse_line/1)
        |> into_index_map

      %__MODULE__{elements: grid, h: Enum.count(grid), w: Enum.count(grid[0])}
    end

    def to_lists(%__MODULE{} = grid) do
      grid.elements
      |> Map.values()
      |> Enum.map(&Map.values/1)
    end

    defp into_index_map(list) do
      list
      |> Enum.with_index(fn element, index -> {index, element} end)
      |> Enum.into(%{})
    end

    defp parse_line(string) do
      string
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)
      |> into_index_map
    end

    def cycle_and_flash(%__MODULE__{} = grid) do
      grid
      |> tick()
      |> flash_tens()
#      |> increment_flash_neighbors()
    end

    def flash_tens(%__MODULE__{} = grid) do
      elements = grid.elements
      |> Map.map(&flash_row/1)

      struct(grid, elements: elements )
    end

    def flash_row({y, row}) do
      row
      |> Map.map(&flash(&1, y))
    end

    def flash({_x,10}, _y), do: :flash
    def flash({_k,v}, _y), do: v

    def cycle_and_count_flashes(%__MODULE{} = grid) do
      grid
      |> tick()
      |> find_10s_increment_neighbors(0)
    end

    def find_10s_increment_neighbors(grid, acc) do
      ten_coords = grid |> find_tens_coords

      neighbors_ticked = increment_tens_neighbors(grid, ten_coords)

      new_grid = neighbors_ticked |> reset_tens(ten_coords)

      {new_grid, Enum.count(ten_coords)}
    end

    def increment_tens_neighbors(grid, tens) do
      ten_neighbors =
        tens
        |> Enum.map(fn x -> neighbors(grid, x) end)
        |> List.flatten()
        |> Enum.concat(tens)

      grid
      |> increment_elements(ten_neighbors)
    end

    defp reset_tens(%__MODULE{} = grid, coords) do
      new_grid = Enum.reduce(coords, grid.elements, &reset/2)

      struct(grid, elements: new_grid)
    end

    def reset({x, y}, elements) do
      put_in(elements[y][x], 0)
    end

    def neighbors(%__MODULE{} = grid, {x1, y1}) do
      x_range = range(x1, grid.w)
      y_range = range(y1, grid.h)
      for x <- x_range, y <- y_range, !(x == x1 and y == y1), do: {x, y}
    end

    defp range(n, max) do
      max(n - 1, 0)..min(n + 1, max - 1)
    end

    def tick(%__MODULE{} = grid) do
      coords = for x <- 0..(grid.w - 1), y <- 0..(grid.h - 1), do: {x, y}
      increment_elements(grid, coords)
    end

    def increment_elements(%__MODULE{} = grid, coords_to_increment) do
      new_grid = Enum.reduce(coords_to_increment, grid.elements, &increment/2)

      struct(grid, elements: new_grid)
    end

    def increment({x, y}, elements) do
      if elements[y][x] != 10 do
        update_in(elements[y][x], &(&1 + 1))
      end
    end

    def find_tens_coords(%__MODULE{} = grid) do
      grid.elements
      |> Map.to_list()
      |> Enum.map(&get_ten_coordinates_from_row/1)
      |> List.flatten()
    end

    defp get_ten_coordinates_from_row({y, row}) do
      row
      |> Map.filter(fn {_k, v} -> v >= 10 end)
      |> Map.keys()
      |> Enum.map(fn x -> {x, y} end)
    end
  end
end
