defmodule DayFour do
  @moduledoc false

  def play_for_loss(file_name) do
    file_name
    |> parse_input
    |> process_draws_to_last_card_win
    |> calc_winning_score
  end

  def parse_input(file_name) do
    Utilities.read_file_into_groups(file_name)
    |> parse_string_groups
  end

  def parse_string_groups([numbers | cards]) do
    draw = numbers |> String.split(",") |> Enum.map(&String.to_integer/1)

    parsed_cards =
      cards
      |> Enum.map(&parse_card/1)
      |> Enum.map(&setup_card/1)

    [draw | parsed_cards]
  end

  def parse_card(card_string) do
    rows = parse_rows(card_string)

    rows ++ build_columns(rows)
  end

  defp parse_rows(card_string) do
    card_string
    |> String.split("\n", trim: true)
    |> Enum.map(fn row -> String.split(row, " ", trim: true) end)
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end

  defp build_columns(rows) do
    rows
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def setup_card(card) do
    card
    |> Enum.map(fn series -> Enum.map(series, fn x -> {x, :o} end) end)
  end

  def process_draws_to_last_card_win([draws | cards]) do
    draws
    |> Enum.reduce_while(cards, &process_draw_for_loss/2)
  end

  def process_draw_for_loss(draw, cards) do
    Enum.map(cards, fn card -> stamp(card, draw) end)
    |> process_stamped_cards_for_loss(draw)
  end

  def process_stamped_cards_for_loss(stamped_cards, draw) do
    case stamped_cards do
      [last] -> process_last_card_for_loss(draw, last)
      ^stamped_cards -> {:cont, Enum.reject(stamped_cards, &is_winner?/1)}
    end
  end

  defp process_last_card_for_loss(draw, card) do
    cond do
      is_winner?(card) -> {:halt, {draw, card}}
      true -> {:cont, [card]}
    end
  end

  def play_for_win(file_name) do
    file_name
    |> parse_input
    |> process_draws_to_winner
    |> calc_winning_score
  end

  def process_draws_to_winner([draws | cards]) do
    draws
    |> Enum.reduce_while(cards, &process_draw_for_win/2)
  end

  def process_draw_for_win(draw, cards) do
    cards
    |> Enum.map(fn card -> stamp(card, draw) end)
    |> process_stamped_for_win(draw)
  end

  def process_stamped_for_win(stamped_cards, draw) do
    case find_winner(stamped_cards) do
      [] -> {:cont, stamped_cards}
      [winning_card] -> {:halt, {draw, winning_card}}
    end
  end

  def calc_winning_score({draw, card}) do
    card_sum =
      card
      |> Enum.take(5)
      |> List.flatten()
      |> Enum.map(fn
        {n, :o} -> n
        {_, :x} -> 0
      end)
      |> Enum.sum()

    card_sum * draw
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
