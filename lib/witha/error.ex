defmodule Witha.Error do
  @moduledoc """
  Either monad chain.

  The typespec of either is `{:ok, term} | {:error, term}`.

      iex> witha Witha.Error, x1 <- {:ok, 1}, do: x1 + 1
      {:ok, 2}

      iex> witha Witha.Error, x1 <- {:error, "駄目"}, do: x1
      {:error, "駄目"}

  `:ok` can chain.

      iex> witha Witha.Error, [
      iex>   x1 <- {:ok, 1},
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

  @doc false
  def wrap(prepare, bindings, do_block) do
    prepare = quote do
      unquote prepare
      error_6f09fb1f5d494b798537c9aff5aab6e1 = nil
    end
    bindings = for {:<-, lines, [matcher, call]} <- List.wrap bindings do
      {
        :<-,
        lines,
        [
          quote(do: {unquote(matcher), error_6f09fb1f5d494b798537c9aff5aab6e1}),
          quote do
            if is_nil error_6f09fb1f5d494b798537c9aff5aab6e1 do
              try do
                case unquote call do
                  {:ok, value} -> {value, nil}
                  {:error, error} -> {nil, error}
                end
              rescue
                error -> {nil, error}
              end
            else
              {nil, error_6f09fb1f5d494b798537c9aff5aab6e1}
            end
          end
        ]
      }
    end
    do_block = quote do
      if is_nil error_6f09fb1f5d494b798537c9aff5aab6e1 do
        {:ok, unquote(do_block)}
      else
        {:error, error_6f09fb1f5d494b798537c9aff5aab6e1}
      end
    end
    {prepare, bindings, do_block}
  end
end
