defmodule WithaTest do
  alias Witha.Nilable

  import Witha

  use ExUnit.Case

  doctest Witha

  # describe "witha" do
  #   test "Works" do
  #     assert 2 == witha(Witha.Nilable, x1 <- 1, do: x1 + 1)
  #   end

  #   test "Aliased aspects" do
  #     assert 2 == witha(Nilable, x1 <- 1, do: x1 + 1)
  #   end

  #   test "Compose multiple aspects" do
  #   end
  # end
end
