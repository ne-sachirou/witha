# Witha
With aspect: Monad chain, like Haskell's `do` or Clojure's `cats.core/alet`.

[![Hex.pm](https://img.shields.io/hexpm/v/witha.svg)](https://hex.pm/packages/witha)
[![Build Status](https://travis-ci.org/ne-sachirou/witha.svg?branch=master)](https://travis-ci.org/ne-sachirou/witha)


[Document](https://hex.pm/docs/witha).

## Installation

Add `witha` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:witha, "~> 0.1.0"}
  ]
end
```

Usage
--
Witha's syntax is very similer to Elixir's [`with`](https://hexdocs.pm/elixir/Kernel.SpecialForms.html#with/1).

```elixir
import Witha

witha Witha.Error, x1 <- {:ok, 1}, do: x1 + 1
# {:ok, 2}

witha Witha.Error,
      [x1 <- {:ok, 1},
       x2 <- {:ok, x1 + 1}],
  do: x1 + x2
# {:ok, 3}
```

Witha takes pre-defined aspects `Witha.Nilable` & `Witha.Error`.

`Witha.Nilable` (Maybe) can chain `term | nil`.

```elixir
witha Witha.Nilable,
      [x1 <- 1,
       x2 <- x1 + 1],
  do: x1 + x2
# 3

witha Witha.Nilable,
      [x1 <- nil,
       x2 <- x1 + 1],
  do: x1 + x2
# nil
```

`Witha.Error` (Either) can chain `{:ok, term} | {:error, term}`.

```elixir
witha Witha.Error,
      [x1 <- {:ok, 1},
       x2 <- {:ok, x1 + 1}],
  do: x1 + x2
# {:ok, 3}

witha Witha.Error,
      [x1 <- {:error, "駄目"},
       x2 <- {:ok, x1 + 1}],
  do: x1 + x2
# {:error, "駄目"}
```

Similer libraries
--
* [ok](https://hex.pm/packages/ok)
* [nickmeharry/elixir-monad](https://github.com/nickmeharry/elixir-monad)
