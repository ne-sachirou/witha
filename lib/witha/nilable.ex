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

  @doc false
  def wrap(prepare, bindings, do_block) do
    prepare = quote do
      unquote prepare
      nil_d30ad395e07d4339aaca73e36e2383ba = true
    end
    bindings = for {:<-, lines, [matcher, call]} <- List.wrap bindings do
      {
        :<-,
        lines,
        [
          matcher,
          quote  do
            nil_d30ad395e07d4339aaca73e36e2383ba =
            if is_nil nil_d30ad395e07d4339aaca73e36e2383ba do
              nil
            else
              try do
                unquote call
              rescue
                _ -> nil
              end
            end
          end
        ]
      }
    end
    do_block = quote do: nil_d30ad395e07d4339aaca73e36e2383ba && unquote(do_block)
    {prepare, bindings, do_block}
  end
end
