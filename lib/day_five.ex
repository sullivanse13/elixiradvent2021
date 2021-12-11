defmodule DayFive do
  @moduledoc false


  def parse_line(line_string) do
    line_string
    |> String.split(~r/( -> |,)/)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
  end

  def is_diagonal?([[x,_],[x,_]]), do: false
  def is_diagonal?([[_,y],[_,y]]), do: false
  def is_diagonal?(_), do: true

  def add_line_to_grid(grid, [[x1,y],[x2,y]]) do

      row = make_zeros(x1,x2) ++ make_ones(x1,x2)

      grid_length = length(grid)

      if grid_length < y do
#        IO.inspect({grid, grid_length,y, y-grid_length})
        add_new_row_to_end(grid_length, y, grid, row)
      else
        existing_row = Enum.at(grid,y)
        zipped_row = merge_rows(row, existing_row, [])
        List.replace_at(grid, zipped_row, y)
      end
  end

  def merge_rows([], [], acc), do: acc |> Enum.reverse
  def merge_rows([], x, acc), do: x ++ acc |> Enum.reverse
  def merge_rows(x, [], acc), do: x ++ acc |> Enum.reverse
  def merge_rows([x], [y], acc), do: [x+y | acc] |> Enum.reverse
  def merge_rows([x|xtl], [y|ytl], acc) do
    merge_rows(xtl,ytl, [x+y | acc])
  end



  defp add_new_row_to_end(grid_length,y,grid,row) do
    empty_rows = create_empty_rows(y-grid_length-1)
    buffered_grid = grid ++ empty_rows
    buffered_grid ++ [row]
  end
  defp create_empty_rows(number_of_rows), do: for _ <- 0..number_of_rows, do: []
  defp make_zeros(0,_), do: []
  defp make_zeros(x1,_), do: for _ <- 0..x1-1, do: 0
  defp make_ones(x1,x2), do: for _ <- x1..x2, do: 1




end
