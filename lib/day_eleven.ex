defmodule DayEleven do
  @moduledoc false


  def part_1(file_name) do

  end

  def part_2(file_name) do

  end

  defmodule Grid do
    defstruct h: 0, w: 0, elements: []

    def new(string) do
      grid =
        string
        |> String.split(~r/\n/, trim: true)
        |> Enum.map(&parse_line/1)

      %__MODULE__{elements: grid, h: length(grid), w: length(Enum.at(grid, 0))}
    end

    def find_tens(%__MODULE{} = grid) do
      grid.elements
      |> Enum.with_index
      |> Enum.map(&get_ten_coords_from_row/1)
      |> List.flatten
    end

    def get_ten_coords_from_row({row, row_index}) do
      row
      |> Enum.with_index
      |> Enum.filter(fn {element, indx} -> element == 10 end)
      |> Enum.map(fn {element, indx} -> {indx, row_index} end)
    end

    def tick(%__MODULE{} = grid) do
      struct(grid, elements: Enum.map((grid.elements), &plus_one/1))
    end

    defp plus_one(list), do: Enum.map(list, fn x -> x+1 end)

    def increment_elements(%__MODULE{} = grid, positions) do
      positions
      |> Enum.group_by(fn {_x,y} -> y end, fn {x,_y} -> x end)
      |> increment_grid_coordinates(grid.elements)
      |> then(fn new_elements -> struct(grid, elements: new_elements) end)
    end

    defp increment_grid_coordinates(coordinates, grid_elements) do
      coordinates
        |> Map.to_list
        |> Enum.reduce(grid_elements, &update_row/2)
    end

    defp update_row({row_index, columns_to_update}, elements) do
      row_to_update = elements |> Enum.at(row_index)

      updated_row =
        columns_to_update
        |> Enum.reduce(row_to_update, fn index, row -> List.update_at(row, index, &(&1 + 1)) end)

      List.replace_at(elements, row_index, updated_row)
    end

    defp parse_line(string) do
      string
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)
    end

  end
end