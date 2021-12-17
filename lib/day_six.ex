defmodule DaySix do
  @moduledoc false

  def simulate_fish_population_from_file(file_name, days) do
    buckets =
      file_name
      |> read_fish_from_file()
      |> to_buckets

      1..days
      |> Enum.reduce(buckets, fn _, b -> decrement_all_buckets(b) end)
      |> Enum.map(fn {_,count} -> count end)
      |> Enum.sum
  end

  def decrement_all_buckets(buckets) do
    buckets
      |> Enum.map(&decrement/1)
      |> List.flatten
      |> Enum.group_by(fn {x,_} -> x end, fn {_,y} -> y end)
      |> Map.to_list
      |> Enum.map(fn {x,y} -> {x, Enum.sum(y)} end)
      |> Enum.sort
  end

  def decrement({0,count}), do: [{6,count}, {8,count}]
  def decrement({days,count}), do: {days-1,count}

  def to_buckets(list) do
    list
    |> Enum.frequencies
    |> Map.to_list
    |> Enum.sort
  end

  defp read_fish_from_file(file_name) do
    file_name
    |> Utilities.read_file_to_list_of_strings()
    |> Enum.map(&Utilities.parse_string_to_int_list/1)
    |> hd
  end

end
