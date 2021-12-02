defmodule Utilities do
  @moduledoc false

  def read_file_to_list_of_strings(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end


  def read_file_into_groups(file_name) do
    file_name
    |> File.read!()
    |> String.split(~r/\n\n/)
  end

end
