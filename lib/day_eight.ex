defmodule DayEight do
  @moduledoc false


  def decode(list, number) do
    mapping = case number do
      0 -> &find_zero/1
      1 -> &find_one/1
      4 -> &find_four/1
      6 -> &find_six/1
      7 -> &find_seven/1
      8 -> &find_eight/1
      9 -> &find_nine/1
    end
    mapping.(list)
  end

  def fetch(list, number) do
    list
    |> decode(number)
    |> Map.fetch!(number)
  end

  def find_one(list), do: find_by_length(list, 2,1)
  def find_four(list), do: find_by_length(list, 4,4)
  def find_seven(list), do: find_by_length(list, 3,7)
  def find_eight(list), do: find_by_length(list, 7,8)

  def find_by_length(list, length, value) do
    list
    |> Enum.filter(fn s -> String.length(s) == length end)
    |> hd
    |> mapping(value)
  end

  def find_six(list) do
    nine = fetch(list, 9)
    zero = fetch(list, 0)
    list
    |> Enum.filter(fn s -> String.length(s) == 6 end)
    |> Enum.reject(fn s -> s == nine end)
    |> Enum.reject(fn s -> s == zero end)
    |> hd
    |> mapping(6)

  end

  def find_zero(list) do
    nine = fetch(list, 9)
    one = fetch(list, 1)

    list
    |> Enum.filter(fn s -> String.length(s) == 6 end)
    |> Enum.reject(fn s -> s == nine end)
    |> Enum.filter(fn s -> is_in?(s,one) end)
    |> hd
    |> mapping(0)

  end

  defp is_in?(container, containee) do
    containee
    |> String.codepoints
    |> Enum.all?(fn c -> String.contains?(container, c) end)
  end

  def find_nine(list) do
    four_code_points = fetch(list,4) |> String.codepoints
    bottom = find_bottom(list) |> Map.fetch!(:b)
    top = find_top(list) |> Map.fetch!(:t)

    nine_characters = [top, bottom | four_code_points] |> Enum.join

    list
    |> Enum.filter(fn s -> contain_same_chars?(s,nine_characters) end)
    |> hd
    |> mapping(9)

  end

  def contain_same_chars?(a,b) do
    Enum.sort(String.codepoints(a)) == Enum.sort(String.codepoints(b))
  end

  def find_top(list) do
    one = Enum.filter(list, fn s -> String.length(s) == 2 end) |> hd
    seven = Enum.filter(list, fn s -> String.length(s) == 3 end) |> hd

    String.codepoints(seven) -- String.codepoints(one)
    |> hd
    |> mapping(:t)
  end

  def find_bottom(list) do

    top = find_top(list) |> Map.fetch!(:t)

    unknown_digits = list |> Enum.reject(fn s ->  Enum.member?([2,3,4],String.length(s)) end)
    count = length(unknown_digits)

    unknown_digits
    |> Enum.map(&String.codepoints/1)
    |> List.flatten
    |> Enum.reject(fn s -> s == top end)
    |> Enum.frequencies
    |> Map.to_list
    |> Enum.filter(fn {_k,v} -> v == count end)
    |> hd
    |> then(fn {bottom, _c} -> mapping(bottom,:b) end)

  end

  defp mapping(x, y), do: %{x => y, y => x}


  def count_easy_digits_from_file(file_name) do
    file_name
    |> Utilities.parse_file_lines_with(&parse_line/1)
    |> Stream.map(&count_easy_digit_size/1)
    |> Enum.sum
  end


  def parse_line(line) do
    [_,output_digits] = String.split(line, ~r/\|/, trim: true)
    output_digits |> String.split
  end

  def count_easy_digit_size(list) do
    Enum.count(list, fn s -> Enum.member?([2,3,4,7],String.length(s)) end)
  end
end
