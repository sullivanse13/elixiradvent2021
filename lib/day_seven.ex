defmodule DaySeven do
  @moduledoc false


  def calculate_fuel_from_file_part_one(file_name) do
    file_name
    |> Utilities.read_file_to_list_of_strings()
    |> Enum.to_list
    |> hd
    |> Utilities.parse_string_to_int_list()
    |> calculate_minimal_fuel_to_align_part_one
  end

  def calculate_minimal_fuel_to_align_part_one(crabs) do
    mean = crabs |> find_optimal_position_part_one

    crabs
    |> calculate_fuel_to_move_all_crabs_part_one(mean)
  end


  def find_optimal_position_part_one(crabs) do
    #median seems to be optimal
    crabs
    |> Enum.sort
    |> Enum.at(div(length(crabs),2))
  end

  def calculate_fuel_to_move_all_crabs_part_one(crabs, position) do
    IO.puts("moving to #{position}")
    crabs
    |> Enum.reduce(0, fn crab_pos, fuel_used -> fuel_used + abs(position-crab_pos) end)
  end

end
