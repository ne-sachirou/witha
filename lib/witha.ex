defmodule Witha do
  @moduledoc """
  With aspect: Monad chain, like Haskell's `do` or Clojure's `cats.core/alet`.
  """

  @doc """
  With aspect: Monad chain, like Haskell's `do` or Clojure's `cats.core/alet`.

  `witha`'s syntax is very similer to Elixir's `with`. See each aspect's documents.
  """
  defmacro witha(aspects, bindings, [do: do_block]) do
    {prepare, bindings, do_block} = aspects
    |> List.wrap
    |> Enum.reduce({nil, List.wrap(bindings), do_block}, fn aspect, {prepare, bindings, do_block} ->
      apply (aspect |> Code.eval_quoted |> elem(0)), :wrap, [prepare, bindings, do_block]
    end)
    quote do
      unquote prepare
      unquote {:with, [], bindings ++ [[do: do_block]]}
   end
  end
end
