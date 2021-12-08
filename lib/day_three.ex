defmodule DayThree do
  @moduledoc false
  use Bitwise



  def get_life_support_rating(file_name) do

    file_input = file_name |> Utilities.read_file_to_list_of_strings() |> Enum.to_list

    bit_width = file_input |> hd |> String.length

    diagnostic = file_input |> binary_strings_to_int

    get_co2_scrubber_rating(diagnostic, bit_width)
      * get_oxygen_generator_rating(diagnostic, bit_width)
  end


  def get_rating([x],_,_), do: x
  def get_rating(int_list, bit_column, func) do
    int_list
    |> group_by_column_bit(bit_column)
    |> Enum.sort_by(func)
    |> hd
    |> elem(1)
    |> get_rating(bit_column-1, func)
  end

  def get_co2_scrubber_rating(list, bit_width) do

    get_rating(list, bit_width, &sort_for_least_common_or_zero/1)
  end

  def get_oxygen_generator_rating(list, bit_width) do
    get_rating(list, bit_width, &sort_for_most_common_or_one/1)
  end

  defp sort_for_least_common_or_zero({k,v}), do: {length(v),k}
  defp sort_for_most_common_or_one({k,v}), do: {-length(v),-k}



  def group_by_column_bit(list, column) do
    list
    |> Enum.group_by(fn x -> x &&& (1 <<< column) end)
    |> Map.to_list
    |> Enum.map(fn {k,v} -> {k >>> column, v} end)
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
