defmodule TestHelpers do
  @moduledoc false
  import ExUnit.Assertions

  def assert_content_equal(actual, expected) do
    assert Enum.sort(actual) == Enum.sort(expected)
    actual
  end

  def assert_map_equal(actual, expected) do
    assert is_map(actual)
    assert Map.keys(expected) == Map.keys(actual)
    assert expected == actual
    actual
  end

  def assert_equal(item, expected) do
    assert expected == item
    item
  end

  def assert_map_has_key_and_value(map, key, value) do
    assert value == Map.fetch!(map, key)
    map
  end

  def assert_length(map, length) when is_map(map) do
    assert length(Map.to_list(map)) == length
    map
  end

  def seconds_since_midnight() do
    Time.utc_now()
    |> Time.to_seconds_after_midnight()
    |> elem(0)
  end

  def assert_starts_with(item, expected) do
    assert String.starts_with?(item, expected)
    item
  end

  def assert_ends_with(item, expected) do
    assert String.ends_with?(item, expected)
    item
  end

  def assert_equals(item, expected) do
    if expected != item do
      IO.inspect("\nexpected: #{expected}")
      IO.inspect("actual: #{item}")
    end

    assert expected == item
    item
  end

  def read_firefly_response_from_file() do
    File.read!("test/support/firefly_usp/firefly_usp_response.bin")
    |> :erlang.binary_to_term()
    |> Enum.map(fn rsp -> {:ok, rsp} end)
    |> FireflyUspResponse.new()
    #    |> fix_missing_credit_cards()
    |> FireflyUspResponse.to_search_response(1423)
  end
end
