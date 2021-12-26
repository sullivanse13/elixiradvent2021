defmodule DayEleven do
  @moduledoc false

  def part_1(_file_name) do
  end

  def part_2(_file_name) do
  end

  defmodule Grid do
    defstruct size: 0, elements: %{}

    def new(string) when is_binary(string) do
      lines =
        string
        |> String.split(~r/\n/, trim: true)

      lines
      |> Enum.with_index()
      |> Enum.map(&parse_line/1)
      |> List.flatten()
      |> Enum.into(%{})
      |> then(fn elements -> %__MODULE__{elements: elements, size: length(lines)} end)
    end

    defp parse_line({string, y}) do
      string
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {digit, x} -> {{x, y}, digit} end)
    end

    def step(%__MODULE__{} = grid) do
      flashed =
        grid.elements
        |> Map.map(fn {_k, v} -> v + 1 end)
        |> find_10s_increment_neighbors(grid.size)


      count = flashed
        |> Map.values()|> Enum.count(fn x -> x == :flashed end)

      tens_reset = Map.map(flashed, &reset/1)

      {struct(grid, elements: tens_reset), count}
    end

    def find_10s_increment_neighbors(new_elements, grid_size) do
      tens = new_elements |> find_10s

      new_elements =
        Enum.reduce(tens, new_elements, fn coord, elements ->
          Map.put(elements, coord, :flashed)
        end)

        tens
        |> Enum.map(fn ten -> neighbors(grid_size, ten) end)
        |> List.flatten()
        |> Enum.reduce(new_elements, fn coord, elements ->
          Map.update!(elements, coord, &flashed/1)
        end)

    end

    def reset({_k, :flashed}), do: 0
    def reset({_k, v}), do: v

    def flashed(:flashed), do: :flashed
    def flashed(v), do: v + 1

    defp find_10s(elements) do
      elements
      |> Map.to_list()
      |> Enum.filter(fn {_k, v} -> v == 10 end)
      |> Enum.map(fn {k, _v} -> k end)
    end

    def neighbors(size, {x1, y1}) do
      x_range = range(x1, size)
      y_range = range(y1, size)
      for x <- x_range, y <- y_range, !(x == x1 and y == y1), do: {x, y}
    end

    defp range(n, max) do
      max(n - 1, 0)..min(n + 1, max - 1)
    end
  end
end
