defmodule DaySeven do
  @moduledoc false

  def calculate_fuel_from_file(file_name) do
    file_name
    |> Utilities.parse_single_line_to_int_list
    |> calculate_minimal_fuel_to_align
  end


  def calculate_minimal_fuel_to_align(crabs) do
    crabs = Enum.sort(crabs)

    {min, max} = Enum.min_max(crabs)

    min..max
    |> Stream.map(fn pos -> calculate_fuel_to_move_all_crabs(crabs, pos) end)
    |> Enum.min

  end



  def calculate_fuel_to_move_all_crabs(crabs, position) do
    crabs
    |> Stream.map(fn crab_pos -> abs(position - crab_pos) end)
    |> Stream.map(fn distance -> Enum.sum(0..distance) end)
    |> Enum.sum

  end

  def find_optimal_position(crabs) do
    crabs
    |> Enum.reduce({0,0}, fn crab_pos, {sum, count} -> {crab_pos+sum, count+1} end)
    |> then(fn {sum, count} -> round(sum/count) end)
  end


  def calculate_fuel_from_file_part_one(file_name) do
    file_name
    |> Utilities.parse_single_line_to_int_list
    |> calculate_minimal_fuel_to_align_part_one
  end

  def calculate_minimal_fuel_to_align_part_one(crabs) do
    mean = crabs |> find_optimal_position_part_one

    crabs
    |> calculate_fuel_to_move_all_crabs_part_one(mean)
  end

  def find_optimal_position_part_one(crabs) do
    # median seems to be optimal
    crabs
    |> Enum.sort()
    |> Enum.at(div(length(crabs), 2))
  end

  def calculate_fuel_to_move_all_crabs_part_one(crabs, position) do
    IO.puts("moving to #{position}")

    crabs
    |> Enum.reduce(0, fn crab_pos, fuel_used -> fuel_used + abs(position - crab_pos) end)
  end
end
