defmodule Witha.Error do
  @moduledoc """
  Either monad chain.

  The typespec of either is `{:ok, term} | {:error, term} | :ok | :error`.

      iex> witha Witha.Error, x1 <- {:ok, 1}, do: x1 + 1
      {:ok, 2}

      iex> witha Witha.Error, x1 <- {:error, "駄目"}, do: x1
      {:error, "駄目"}

      iex> witha Witha.Error, _ <- :ok, do: 42
      {:ok, 42}

      iex> witha Witha.Error, _ <- :error, do: 42
      {:error, :error}

  `:ok` can chain.

      iex> witha Witha.Error, [
      iex>   x1 <- {:ok, 1},
      iex>   _  <- :ok,
      iex>   x2 <- {:ok, x1 + 1},
      iex> ], do: x1 + x2
      {:ok, 3}

  `:error` & `raise` stops the chain.

      iex> witha Witha.Error, [
      iex>   x1 <- {:error, "駄目"},
      iex>   x2 <- {:ok, x1 + 1},
      iex> ], do: x1 + x2
      {:error, "駄目"}

      iex> witha Witha.Error, [
      iex>   x1 <- raise("駄目"),
      iex>   x2 <- {:ok, x1 + 1},
      iex> ], do: x1 + x2
      {:error, %RuntimeError{message: "駄目"}}
  """

  @behaviour Witha.Aspect

  def new(right), do: quote(do: {:ok, unquote(right)})

  def flat_map(either, call) do
    quote do
      case unquote either do
        {:ok, _} ->
          case unquote call do
            {:ok, right} -> {{:ok, right}, right}
            :ok -> {{:ok, nil}, nil}
            {:error, left} -> {{:error, left}, nil}
            :error -> {{:error, :error}, nil}
          end
        {:error, left} -> {{:error, left}, nil}
      end
    end
  end

  def handle_error(error), do: {:error, error}
end
