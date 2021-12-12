defmodule DaySix do
  @moduledoc false

  def simulate_fish_population_from_file(file_name, days) do

    1..days
    |> Enum.reduce(read_fish_from_file(file_name), fn _,fish_acc -> cycle(fish_acc, []) end)
    |> Enum.count
  end

  defp read_fish_from_file(file_name) do
    file_name
    |> Utilities.read_file_to_list_of_strings()
    |> Enum.map(&Utilities.parse_string_to_int_list/1)
    |> hd
  end

  def cycle([],acc), do: acc |> Enum.reverse
  def cycle([0|tl],acc), do: cycle(tl, [8,6|acc])
  def cycle([x|tl],acc), do: cycle(tl, [x-1|acc])

end
