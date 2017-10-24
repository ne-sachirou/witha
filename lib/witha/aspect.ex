defmodule Witha.Aspect do
  @moduledoc false

  @callback new(term) :: term

  @callback flat_map(term, term) :: {term, term}

  @callback handle_error(Exception.t) :: term
end
