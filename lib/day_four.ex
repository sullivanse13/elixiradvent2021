defmodule DayFour do
  @moduledoc false


  def play_for_win(file_name) do
    file_name
    |> parse_input
    |> process_draws_to_winner
    |> calc_winning_score

  end

  def process_draws_to_winner([draws | cards]) do
    draws
    |> Enum.reduce_while(cards, &process_draw/2)
  end

  def process_draw(draw,cards) do
    cards
    |> Enum.map(fn card -> stamp(card, draw) end)
    |> process_stamped(draw)
  end


  def process_stamped(stamped_cards, draw) do
    case find_winner(stamped_cards) do
      [] -> {:cont, stamped_cards}
      [winning_card] -> {:halt, {draw, winning_card}}
    end
  end

  def calc_winning_score({draw, card}) do
    card_sum = card
    |> Enum.take(5)
    |> List.flatten
    |> Enum.map(fn
      {n,:o} -> n
      {_,:x} -> 0
    end)
    |> Enum.sum

    card_sum * draw
  end

  def parse_input(file_name) do
    [numbers | cards] = Utilities.read_file_into_groups(file_name)

    draw = numbers |> String.split(",") |> Enum.map(&String.to_integer/1)

    parsed_cards =
      cards
      |> Enum.map(&parse_card/1)
      |> Enum.map(&setup_card/1)

    [draw | parsed_cards]
  end

  def parse_card(card_string) do
    rows =
      card_string
      |> String.split("\n", trim: true)
      |> Enum.map(fn row -> String.split(row, " ", trim: true) end)
      |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)

    columns =
      rows
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    rows ++ columns
  end

  def setup_card(card) do
    card
    |> Enum.map(fn series -> Enum.map(series, fn x -> {x, :o} end) end)
  end

  def stamp(card, draw) do
    card
    |> Enum.map(fn series -> Enum.map(series, fn x -> stamp_number(x, draw) end) end)
  end

  def stamp_number({n, :o}, n), do: {n, :x}
  def stamp_number(n, _), do: n

  def is_winner?(card) do
    card
    |> Enum.map(fn series -> Enum.all?(series, fn {_, stamp} -> stamp == :x end) end)
    |> Enum.any?()
  end

  def find_winner(cards) do
    cards
    |> Enum.filter(&is_winner?/1)
  end
end
