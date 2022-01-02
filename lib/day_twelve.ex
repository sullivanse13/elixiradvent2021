defmodule DayTwelve do
  @moduledoc false

  def part_1(file_name) do
    file_name
    |> Utilities.read_file_to_list_of_strings()
    |> parse_lines
    |> count_paths
  end

  def part_2(_file_name) do
  end

  def count_paths(connection_map) do
    connection_map
    |> find_paths
    |> Enum.count()
  end

  def find_paths(connection_map) do
    {start_neighbors, connection_map_no_start} = Map.pop!(connection_map, "start")

    {"start", start_neighbors}
    |> find_path_from(connection_map_no_start, ["start"], MapSet.new())
    |> List.flatten()
  end

  def find_path_from({"end", _}, _connection_map, acc, _no_backtrack_set),
    do: acc |> Enum.reverse() |> List.to_tuple()

  def find_path_from({cave, neighbors}, connection_map, acc, no_backtrack_set) do
    no_back_track = keep_backtrack_from_happening(no_backtrack_set, cave)

    paths =
      for n <- neighbors,
          !MapSet.member?(no_back_track, n),
          do: find_path_from({n, connection_map[n]}, connection_map, [n | acc], no_back_track)

    paths
  end

  defp keep_backtrack_from_happening(no_backtrack_set, cave) do
    if cave == String.downcase(cave) do
      MapSet.put(no_backtrack_set, cave)
    else
      no_backtrack_set
    end
  end

  def parse_lines(lines) do
    lines
    |> Enum.map(&parse_line/1)
    |> List.flatten()
    |> Enum.group_by(&key/1, &value/1)
  end

  defp key({k, _v}), do: k
  defp value({_k, v}), do: v

  defp parse_line(line) do
    line
    |> String.split(~r/-/)
    |> parse_connection
  end

  defp parse_connection(["end", x]), do: [{x, "end"}]
  defp parse_connection([x, "end"]), do: [{x, "end"}]
  defp parse_connection(["start", x]), do: [{"start", x}]
  defp parse_connection([x, "start"]), do: [{"start", x}]
  defp parse_connection([x, y]), do: [{x, y}, {y, x}]
end
