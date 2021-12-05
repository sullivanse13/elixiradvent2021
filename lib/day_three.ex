defmodule DayThree do
  @moduledoc false


  def power_consumption_from_file(file_name) do
    file_name
    |> Utilities.read_file_to_list_of_strings()
    |> make_columns
    |> Enum.map(&get_most_least_common/1)
    |> build_epsilon_gamma
    |> Enum.product
  end

  def build_epsilon_gamma(list) do
    list
    |> Enum.zip
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn x -> Enum.join(x,"") end)
    |> Enum.map(fn x -> String.to_integer(x,2) end)
  end

  def get_most_least_common(list) do
    list
    |> Enum.frequencies()
    |> Map.to_list
    |> Enum.sort_by(fn {_val, count} -> count end)
    |> Enum.map(fn {val,_} -> val end)
  end

  def make_columns(list) do
    list
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
    |> Enum.zip
    |> Enum.map(&Tuple.to_list/1)
  end
end
