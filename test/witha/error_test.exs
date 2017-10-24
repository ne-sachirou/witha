defmodule Witha.ErrorTest do
  import Witha

  use ExUnit.Case

  doctest Witha.Error

  test "CaseClauseError" do
    assert {:ok, 42} == witha Witha.Error, [x] <- {:ok, [42]}, do: x
    assert {:error, %MatchError{term: {{:ok, []}, []}}} ==
      witha Witha.Error, [x] <- {:ok, []}, do: x
    # assert {:error, "駄目"} == witha Witha.Error, [x] <- {:error, "駄目"}, do: x
  end
end
