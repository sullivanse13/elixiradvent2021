defmodule DayFourTest do
  use ExUnit.Case
  import DayFour

  @docp """
  TDD todo list
  [ ]

  [x] play for loss
  [x] find last winning card


  [x] reduce cards to winner from moves
  [x] calculate score from unmarked * winning number
  [x] split file to moves and cards
  [x] parse moves
  [x] check card series for winners
  [x] stamp winners in card series
  [x] parse cards into rows 'series'
  [x] parse card columns into 'series'
  [ ]
  """

  @mini_card [[{10, :o}, {2, :o}], [{11, :o}, {4, :o}]]
  @winning_card [[{10, :o}, {2, :o}], [{11, :x}, {4, :x}]]
  @one_stamp_card [[{10, :o}, {2, :o}], [{11, :x}, {4, :o}]]

  test "process until last card wins" do
    test =
      """
      1,2,3,4,5,6

      1 2
      3 4

      1 4
      2 8

      1 6
      8 9
      """
      |> String.split(~r/\n\n/, trim: true)
      |> Enum.map(&String.trim/1)
      |> parse_string_groups

    assert process_draws_to_last_card_win(test) ==
             {6,
              [
                [{1, :x}, {6, :x}],
                [{8, :o}, {9, :o}],
                [{1, :x}, {8, :o}],
                [{6, :x}, {9, :o}]
              ]}
  end

  test "play part 2 for loss" do
    play_for_loss("priv/day_four_input.txt")
    |> then(fn score -> "Last winning score for part 2: #{score}\n" end)
    |> IO.puts()
  end

  test "find worst card" do
    assert play_for_loss("priv/day_four_test_input.txt") == 1924
  end

  test "play_for_win game part 1 with squid" do
    play_for_win("priv/day_four_input.txt")
    |> then(fn score -> "Winning score for part 1: #{score}\n" end)
    |> IO.puts()
  end

  test "play_for_win game until winner" do
    assert play_for_win("priv/day_four_test_input.txt") == 4512
  end

  test "parse input" do
    [numbers | cards] = parse_input("priv/day_four_test_input.txt")

    assert numbers == [
             7,
             4,
             9,
             5,
             11,
             17,
             23,
             2,
             0,
             14,
             21,
             24,
             10,
             16,
             13,
             6,
             15,
             25,
             12,
             22,
             18,
             20,
             8,
             19,
             3,
             26,
             1
           ]

    assert length(cards) == 3
    assert hd(hd(cards)) == [{22, :o}, {13, :o}, {17, :o}, {11, :o}, {0, :o}]
  end

  test "find winning card" do
    [@mini_card, @winning_card, @one_stamp_card]
    |> find_winner()
    |> then(fn [x] -> assert x == @winning_card end)
  end

  test "no winning card" do
    [@mini_card, @one_stamp_card]
    |> find_winner()
    |> then(fn x -> assert Enum.empty?(x) end)
  end

  test "check if card is winner" do
    refute is_winner?(@mini_card)
    assert is_winner?(@winning_card)
  end

  test "stamp card for drawn number" do
    assert stamp(@mini_card, 15) == @mini_card
    assert stamp(@mini_card, 11) == @one_stamp_card
  end

  test "parse card rows and columns into series" do
    card = """
    22 13
    8  2
    """

    assert parse_card(card) == [
             [22, 13],
             [8, 2],
             [22, 8],
             [13, 2]
           ]
  end

  test "setup card" do
    assert setup_card([[10, 2], [11, 4]]) == @mini_card
  end
end
