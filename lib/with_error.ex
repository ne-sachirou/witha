defmodule WithError do
  @moduledoc """
  Either monad chain, like Haskell's `do` or Clojure's `cats.core/alet`.
  """

  @doc """
  Either monad chain, like Haskell's `do` or Clojure's `cats.core/alet`.

  The typespec of either is `{:ok, term} | {:error, term}`.
  `with_error`'s syntax is very similer to Elixir's `with`.

      iex> with_error x1 <- {:ok, 1}, do: x1 + 1
      {:ok, 2}

      iex> with_error x1 <- {:error, "駄目"}, do: x1
      {:error, "駄目"}

  `:ok` can chain.

      iex> with_error [
      iex>   x1 <- {:ok, 1},
      iex>   x2 <- {:ok, x1 + 1},
      iex> ], do: x1 + x2
      {:ok, 3}

  `:error` & `raise` stop the chain.

      iex> with_error [
      iex>   x1 <- {:error, "駄目"},
      iex>   x2 <- {:ok, x1 + 1},
      iex> ], do: x1 + x2
      {:error, "駄目"}

      iex> with_error [
      iex>   x1 <- raise("駄目"),
      iex>   x2 <- {:ok, x1 + 1},
      iex> ], do: x1 + x2
      {:error, %RuntimeError{message: "駄目"}}
  """
  defmacro with_error(bindings, [do: do_block]) do
    with_bindings = for {:<-, lines, [matcher, call]} <- List.wrap bindings do
      {
        :<-,
        lines,
        [
          quote(do: {unquote(matcher), error}),
          quote do
            if is_nil error do
              try do
                case unquote call do
                  {:ok, value} -> {value, nil}
                  {:error, error} -> {nil, error}
                end
              rescue
                error -> {nil, error}
              end
            else
              {nil, error}
            end
          end
        ]
      }
    end
    with_do_block = quote do
      if is_nil(error), do: {:ok, unquote(do_block)}, else: {:error, error}
    end
    quote do
      error = nil
      unquote {:with, [], with_bindings ++ [[do: with_do_block]]}
    end
  end
end
