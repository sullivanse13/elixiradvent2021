defmodule DayOne do
  @moduledoc false


  def count_sliding_sum_increases_from_file(file_name) do
    file_name
    |> read_file_to_integer_list
    |> create_sliding_sum
    |> count_increasing
  end

  defp read_file_to_integer_list(file_name) do
    file_name
    |> Utilities.read_file_to_list_of_strings()
    |> Enum.map(&String.to_integer/1)
  end

  def create_sliding_sum(list) do
    list
    |> Enum.chunk_every(3,1,:discard)
    |> Enum.map(&Enum.sum/1)
  end

  def count_increasing_from_file(file_name) do
    file_name
    |> read_file_to_integer_list
    |> count_increasing
  end



  def count_increasing(list) do
    list
    |> Enum.zip(tl(list))
    |> Enum.count(fn {x,y} -> x < y end)
  end

end
