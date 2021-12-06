defmodule DayThree do
  @moduledoc false
  use Bitwise

  def get_oxygen_generator_rating([x], _), do: x
  def get_oxygen_generator_rating(int_list, -1), do: int_list |> hd
  def get_oxygen_generator_rating(int_list, bit_column) do
    int_list
    |> group_by_column_bit(bit_column)
    |> pick_most_common_or_one
    |> get_oxygen_generator_rating(bit_column-1)
  end

  def pick_most_common_or_one([{_, list}]), do: list
  def pick_most_common_or_one([{most_common, mc_list}, {_, lc_list}]) do
    case length(mc_list) == length(lc_list) do
      false -> mc_list
      true -> if most_common == 1 do
                mc_list
              else
                lc_list
              end
    end
  end

  def group_by_column_bit(list, column) do
    list
    |> Enum.group_by(fn x -> x &&& (1 <<< column) end)
    |> Map.to_list
    |> Enum.map(fn {k,v} -> {k >>> column, v} end)
    |> Enum.sort_by(fn {_k,v} -> -length(v) end)
  end

  def binary_strings_to_int(list), do: list |> Enum.map(fn x -> String.to_integer(x,2) end)

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
    |> Enum.map(fn x -> Integer.undigits(x,2) end)
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
