defmodule DayFiveTest do
  use ExUnit.Case
  import DayFive

  @docp """
  TDD todo list
  [ ]

  [x] increment horizontal on empty grid
  [ ] increment horizontal on grid with ones grid
  [ ] increment horizontal on grid with ones grow grid
  [x] add rows to grid
  [ ] increment vertical on grid
  [ ] filter diagonal lines
  [ ] grow grid to fit new lines
  [ ] count number greater than 1
  [x] test for diagonal
  [x] parse lines
  """
#
#  test "increment horizontal on grid" do
#    grid = [[1,1,1,1,1]]
#    assert add_line_to_grid(grid, [[1,0],[2,0]]) ==
#             [
#               [1,2,2,1,1]
#             ]
#
#  end

  test "merge rows" do
    assert merge_rows([],[1], []) == [1]
    assert merge_rows([1],[], []) == [1]
    assert merge_rows([1,2],[], []) == [1,2]
    assert merge_rows([1],[1], []) == [2]
    assert merge_rows([1,0],[0,1], []) == [1,1]
    assert merge_rows([1,1,1,1],[0,1], []) == [1,2,1,1]
  end

  test "add rows to grid" do
    grid = [[0,0,0,0,0]]
    assert add_line_to_grid(grid, [[0,3],[4,3]]) ==
             [
               [0,0,0,0,0],
               [],
               [],
               [1,1,1,1,1]
             ]

    assert add_line_to_grid(grid, [[0,1],[4,1]]) ==
             [
               [0,0,0,0,0],
               [1,1,1,1,1]
             ]
  end

  test "increment horizontal on empty grid left zero pad" do
    grid = []
    assert add_line_to_grid(grid, [[2,0],[4,0]]) == [[0,0,1,1,1]]
  end

  test "increment horizontal on empty grid" do
    grid = []
    assert add_line_to_grid(grid, [[0,0],[4,0]]) == [[1,1,1,1,1]]
  end

  test "parse line" do
    assert parse_line("0,9 -> 5,9") == [[0,9],[5,9]]
  end

  test "diagonal test" do
    refute is_diagonal?([[0,9],[5,9]])
    refute is_diagonal?([[0,1],[0,9]])
    assert is_diagonal?([[0,1],[1,2]])
  end




end
