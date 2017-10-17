defmodule Witha.Aspect do
  @moduledoc false

  @callback wrap(term, [term], term) :: {term, [term], term}
end
