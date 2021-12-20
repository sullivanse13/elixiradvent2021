defmodule DayEight do
  @moduledoc false

  def sum_codes(file_name) do
    file_name
    |> Utilities.parse_file_lines_with(&decode_line/1)
    |> Enum.sum()
  end

  def decode_line(string) do
    {code, digits} = parse_sort_line(string)

    broken_code =
      0..9
      |> Enum.map(fn n -> map(n, code) end)
      |> Enum.reduce(%{}, fn map, acc -> Map.merge(map, acc) end)

    digits
    |> Enum.map(fn digit -> Map.fetch!(broken_code, digit) end)
    |> Enum.join()
    |> String.to_integer()
  end

  def parse_sort_line(string) do
    [code, digits] = String.split(string, ~r/\|/) |> Enum.map(&String.split/1)

    sorted_codes =
      code
      |> Enum.map(&String.codepoints/1)
      |> Enum.map(&Enum.sort/1)
      |> Enum.map(&Enum.join/1)

    sorted_digits =
      digits
      |> Enum.map(&String.codepoints/1)
      |> Enum.map(&Enum.sort/1)
      |> Enum.map(&Enum.join/1)

    {sorted_codes, sorted_digits}
  end

  def map(number, list), do: decode(list, number)

  def decode(list, number) do
    mapping =
      case number do
        0 -> &find_zero/1
        1 -> &find_one/1
        2 -> &find_two/1
        3 -> &find_three/1
        4 -> &find_four/1
        5 -> &find_five/1
        6 -> &find_six/1
        7 -> &find_seven/1
        8 -> &find_eight/1
        9 -> &find_nine/1
      end

    mapping.(list)
  end

  def fetch(list, numbers) when is_list(numbers),
    do: numbers |> Enum.map(fn n -> fetch(list, n) end)

  def fetch(list, number) do
    list
    |> decode(number)
    |> Map.fetch!(number)
  end

  def find_one(list), do: find_by_length(list, 2, 1)
  def find_four(list), do: find_by_length(list, 4, 4)
  def find_seven(list), do: find_by_length(list, 3, 7)
  def find_eight(list), do: find_by_length(list, 7, 8)

  def find_by_length(list, length, value) do
    list
    |> filter_length(length)
    |> hd
    |> mapping(value)
  end

  def find_zero(list) do
    nine = fetch(list, 9)
    one = fetch(list, 1)

    list
    |> filter_length(6)
    |> reject_in([nine])
    |> Enum.filter(fn s -> is_subset?(s, one) end)
    |> hd
    |> mapping(0)
  end

  def find_two(list) do
    list
    |> filter_length(5)
    |> reject_in(fetch(list, [3, 5]))
    |> hd
    |> mapping(2)
  end

  def find_three(list) do
    one = fetch(list, 1)

    list
    |> filter_length(5)
    |> Enum.filter(fn s -> is_subset?(s, one) end)
    |> hd
    |> mapping(3)
  end

  def find_five(list) do
    nine = fetch(list, 9)

    list
    |> filter_length(5)
    |> reject_in(fetch(list, [3]))
    |> Enum.filter(fn s -> is_subset?(nine, s) end)
    |> hd
    |> mapping(5)
  end

  def find_six(list) do
    list
    |> filter_length(6)
    |> reject_in(fetch(list, [0, 9]))
    |> hd
    |> mapping(6)
  end

  def find_nine(list) do
    four_code_points = fetch(list, 4) |> String.codepoints()
    bottom = find_bottom(list) |> Map.fetch!(:b)
    top = find_top(list) |> Map.fetch!(:t)

    nine_characters = [top, bottom | four_code_points] |> Enum.join()

    list
    |> Enum.filter(fn s -> contain_same_chars?(s, nine_characters) end)
    |> hd
    |> mapping(9)
  end

  defp filter_length(list, length) do
    list
    |> Enum.filter(fn s -> String.length(s) == length end)
  end

  defp reject_in(list, rejects) do
    list
    |> Enum.reject(fn s -> s in rejects end)
  end

  defp is_subset?(container, subset) do
    subset
    |> String.codepoints()
    |> Enum.all?(fn c -> String.contains?(container, c) end)
  end

  def contain_same_chars?(a, b) do
    Enum.sort(String.codepoints(a)) == Enum.sort(String.codepoints(b))
  end

  def find_top(list) do
    one = fetch(list, 1)
    seven = fetch(list, 7)

    (String.codepoints(seven) -- String.codepoints(one))
    |> hd
    |> mapping(:t)
  end

  def find_bottom(list) do
    top = find_top(list) |> Map.fetch!(:t)

    unknown_digits = list |> Enum.reject(fn s -> Enum.member?([2, 3, 4], String.length(s)) end)
    count = length(unknown_digits)

    unknown_digits
    |> Enum.map(&String.codepoints/1)
    |> List.flatten()
    |> Enum.reject(fn s -> s == top end)
    |> Enum.frequencies()
    |> Map.to_list()
    |> Enum.filter(fn {_k, v} -> v == count end)
    |> hd
    |> then(fn {bottom, _c} -> mapping(bottom, :b) end)
  end

  defp mapping(x, y), do: %{x => y, y => x}

  def count_easy_digits_from_file(file_name) do
    file_name
    |> Utilities.parse_file_lines_with(&parse_line/1)
    |> Stream.map(&count_easy_digit_size/1)
    |> Enum.sum()
  end

  def parse_line(line) do
    [_, output_digits] = String.split(line, ~r/\|/, trim: true)
    output_digits |> String.split()
  end

  def count_easy_digit_size(list) do
    Enum.count(list, fn s -> Enum.member?([2, 3, 4, 7], String.length(s)) end)
  end
end
