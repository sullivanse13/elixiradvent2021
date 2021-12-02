defmodule DayTwo do
  @moduledoc false

  def read_file_calculate_product_of_position(file_name) do
    file_name
    |> Utilities.read_file_to_list_of_strings()
    |> process_commands
    |> Tuple.product
  end

  def process_commands(list) do
    list
    |> Enum.map(&parse/1)
    |> Enum.reduce({0,0}, &move/2)
  end

  def move({h_pos,d_pos}, {h,d}), do: {h_pos+h, d_pos+d}

  def parse(string) do
    string
    |> String.split
    |> parse_int
    |> process_command
  end

  def parse_int([command, magnitude]), do: [command, String.to_integer(magnitude)]

  def process_command(["forward", x]), do: {x, 0}
  def process_command(["down", x]), do: {0, x}
  def process_command(["up", x]), do: {0, -1*x}

end
