defmodule DayEleven do
  @moduledoc false


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

      count = flashed |> Map.values() |> Enum.count(fn x -> x == :flashed end)

      tens_reset = Map.map(flashed, &reset/1)

      {struct(grid, elements: tens_reset), count}
    end

    def find_10s_increment_neighbors(new_elements, grid_size) do
      tens = new_elements |> find_10s

      if Enum.empty?(tens) do
        new_elements
      else
        flashed_tens = flash_tens(tens, new_elements)
        tens
        |> increment_tens_neighbors(flashed_tens, grid_size)
        |> find_10s_increment_neighbors(grid_size)
      end
    end

    def increment_tens_neighbors(tens, grid_elements, grid_size) do
      tens
      |> Enum.map(fn ten -> neighbors(grid_size, ten) end)
      |> List.flatten()
      |> Enum.reduce(grid_elements, fn coord, elements ->
        Map.update!(elements, coord, &increment/1)
      end)
    end

    def flash_tens(tens, grid_elements) do
      tens
      |> Enum.reduce(grid_elements, fn coord, elements ->
        Map.put(elements, coord, :flashed)
      end)
    end
    def reset({_k, :flashed}), do: 0
    def reset({_k, v}), do: v

    def increment(:flashed), do: :flashed
    def increment(10), do: 10
    def increment(v), do: v + 1

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


  def part_1(file_name) do
    file_name
    |> File.read!
    |> DayEleven.Grid.new
    |> run_steps(100)
    |> then(fn {_grid, flash_count} -> flash_count end)
  end

  defp run_steps(%DayEleven.Grid{} = grid, steps) do
    1..steps
    |> Enum.reduce({grid,0}, &step_with_total/2)
  end

  def step_with_total(_, {%DayEleven.Grid{} = grid, flashes}) do
    grid
    |> DayEleven.Grid.step
    |> then(fn {grid, new_flashes} -> {grid, flashes+new_flashes} end)
  end

end
