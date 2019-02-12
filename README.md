# HAL

Generate JSON in [HAL](http://stateless.co/hal_specification.html) format.

## Usage

```elixir
alias HAL.{Document, Link, Embed}

document = 
  %Document{}
  |> Document.add_link(%Link{rel: "self", href: "/foo"})
  |> Document.add_property(:foo, 42)
  |> Document.add_property(:bar, "baz")
  |> Document.add_embed(%Embed{resource: "rad:podcast", embed: %HAL.Document{properties: %{id: 18}}})

# %HAL.Document{
#   embeds: [
#     %HAL.Embed{
#       embed: %HAL.Document{embeds: [], links: [], properties: %{id: 18}}# ,
#       resource: "rad:podcast"
#     }
#   ],
#   links: [%HAL.Link{href: "/foo", rel: "self", title: nil}],
#   properties: %{bar: "baz", foo: 42}
# }  

Jason.encode!(document)
# {
#   "bar": "baz",
#   "foo": 42,
#   "_embedded": {
#       "rad:podcast": {
#         "id": 18
#     }
#   },
#   "_links": {
#       "self": {
#         "href": "/foo"
#     }
#   }
# }
```

## Installation

_(not yet available on hex)_

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hal` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hal, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/hal](https://hexdocs.pm/hal).

