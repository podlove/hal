# HAL

[![Build Status](https://travis-ci.org/podlove/hal.svg?branch=master)](https://travis-ci.org/podlove/hal)

Generate JSON in [HAL](http://stateless.co/hal_specification.html) format for REST APIs.

## Installation

The package can be installed by adding `hal` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hal, "~> 1.0.0"}
  ]
end
```

## Basic Usage

Build a `HAL.Document`:

```elixir
alias HAL.{Document, Link, Embed}

document = 
  %Document{}
  |> Document.add_link(%Link{rel: "self", href: "/foo"})
  |> Document.add_property(:foo, 42)
  |> Document.add_property(:bar, "baz")
  |> Document.add_embed(%Embed{resource: "rad:podcast", embed: %HAL.Document{properties: %{id: 18}}})
```

Then use `Jason` to encode it to JSON:

```elixir
Jason.encode!(document)
```

```json
{
  "bar": "baz",
  "foo": 42,
  "_embedded": {
      "rad:podcast": {
        "id": 18
    }
  },
  "_links": {
      "self": {
        "href": "/foo"
    }
  }
}
```

Instead of using the Document builder, you can handwrite the `HAL.Document`:

```elixir
%HAL.Document{
  embeds: [
    %HAL.Embed{
      embed: %HAL.Document{embeds: [], links: [], properties: %{id: 18}},
      resource: "rad:podcast"
    }
  ],
  links: [%HAL.Link{href: "/foo", rel: "self", title: nil}],
  properties: %{bar: "baz", foo: 42}
}
|> Jason.encode!()
```

## License

HAL is released under the MIT License - see the [LICENSE](https://github.com/podlove/hal/blob/master/LICENSE) file.
