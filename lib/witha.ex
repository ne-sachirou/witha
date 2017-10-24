defmodule Witha do
  @moduledoc """
  With aspect: Monad chain, like Haskell's `do` or Clojure's `cats.core/alet`.
  """

  @doc """
  With aspect: Monad chain, like Haskell's `do` or Clojure's `cats.core/alet`.

  `witha`'s syntax is very similer to Elixir's `with`. See each aspect's documents.
  """
  defmacro witha(aspects, bindings, [do: do_block]) do
    [aspect | _] = aspects |> List.wrap |> Enum.map(&(&1 |> Code.eval_quoted |> elem(0)))
    body = Enum.concat([
      List.wrap(quote do
        value_6380e49e92684693848d33175bbc7cfe = unquote(aspect.new quote(do: nil))
      end),
      for {:<-, _lines, [matcher, call]} <- List.wrap bindings do
        quote do
          # {value_6380e49e92684693848d33175bbc7cfe, result_f0669f90ff9a476fa468447c0f8da6d3} =
          {value_6380e49e92684693848d33175bbc7cfe, unquote(matcher)} =
            unquote(aspect.flat_map quote(do: value_6380e49e92684693848d33175bbc7cfe), call)
        end
      end,
      List.wrap(quote do
        {value_6380e49e92684693848d33175bbc7cfe, _} =
          unquote aspect.flat_map(quote(do: value_6380e49e92684693848d33175bbc7cfe), aspect.new(do_block))
        value_6380e49e92684693848d33175bbc7cfe
      end),
    ])
    quote do
      try do
        unquote {:__block__, [], body}
      rescue
        error -> unquote(aspect).handle_error error
      end
    end
  end
end
