defmodule Witha.Nilable do
  @moduledoc """
  Maybe monad chain.

  Typespec of maybe is `term | nil`.

      iex> witha Witha.Nilable, x1 <- 1, do: x1 + 1
      2

      iex> witha Witha.Nilable, x1 <- nil, do: x1 + 1
      nil

  Just `term` can chain.

      iex> witha Witha.Nilable, [
      iex>   x1 <- 1,
      iex>   x2 <- x1 + 1,
      iex> ], do: x1 + x2
      3

  `nil` & `raise` stops the chain.

      iex> witha Witha.Nilable, [
      iex>   x1 <- nil,
      iex>   x2 <- x1 + 1,
      iex> ], do: x1 + x2
      nil

      iex> witha Witha.Nilable, [
      iex>   x1 <- raise("駄目"),
      iex>   x2 <- {:ok, x1 + 1},
      iex> ], do: x1 + x2
      nil
  """

  @behaviour Witha.Aspect

  def new(nil), do: true
  def new(just), do: just

  def flat_map(maybe, call) do
    quote do
      case unquote maybe do
        nil -> {nil, nil}
        _ ->
          case unquote call do
            nil -> {nil, nil}
            just -> {just, just}
          end
      end
    end
  end

  def handle_error(_error), do: nil
end
