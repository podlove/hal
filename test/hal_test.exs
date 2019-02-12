defmodule HALTest do
  use ExUnit.Case
  doctest HAL

  alias HAL.Document
  alias HAL.Embed
  alias HAL.Link

  test "can add links" do
    doc1 = %HAL.Document{
      links: [
        %Link{rel: "self", href: "/foo"},
        %Link{rel: "next", href: "/foo?page=2", title: "Page 2"}
      ]
    }

    doc2 =
      %Document{}
      |> Document.add_link(%Link{rel: "self", href: "/foo"})
      |> Document.add_link(%Link{rel: "next", href: "/foo?page=2", title: "Page 2"})

    assert format(doc1) == format(doc2)
  end

  test "can add properties" do
    doc1 = %HAL.Document{properties: %{foo: 42, bar: "baz"}}

    doc2 =
      %HAL.Document{}
      |> Document.add_property(:foo, 42)
      |> Document.add_property(:bar, "baz")

    assert format(doc1) == format(doc2)
  end

  test "can add embeds" do
    podcast = %HAL.Document{properties: %{id: 18}}
    episode1 = %HAL.Document{properties: %{id: 81}}
    episode2 = %HAL.Document{properties: %{id: 82}}

    doc1 = %HAL.Document{
      embeds: [
        %Embed{resource: "rad:podcast", embed: podcast},
        %Embed{resource: "rad:episode", embed: [episode1, episode2]}
      ]
    }

    doc2 =
      %HAL.Document{}
      |> Document.add_embed(%Embed{resource: "rad:podcast", embed: podcast})
      |> Document.add_embed(%Embed{resource: "rad:episode", embed: [episode1, episode2]})

    assert format(doc1) == format(doc2)
  end

  test "renders empty document" do
    assert Jason.encode!(%Document{}) == "{}"
  end

  test "renders properties" do
    document = %HAL.Document{properties: %{foo: 42, bar: "baz"}}

    assert Jason.encode!(document) == format(~S({"foo": 42, "bar": "baz"}))
  end

  test "renders links" do
    document = %HAL.Document{
      links: [
        %Link{rel: "self", href: "/foo"},
        %Link{rel: "next", href: "/foo?page=2", title: "Page 2"}
      ]
    }

    assert Jason.encode!(document) == format(~S(
      {
        "_links": {
          "self": { "href": "/foo" },
          "next": { "href": "/foo?page=2", "title": "Page 2"}
         }
      }
    ))
  end

  test "renders embeds" do
    podcast = %HAL.Document{properties: %{id: 18}}
    episode1 = %HAL.Document{properties: %{id: 81}}
    episode2 = %HAL.Document{properties: %{id: 82}}

    document = %HAL.Document{
      properties: %{title: "Example"},
      embeds: [
        %Embed{resource: "rad:podcast", embed: podcast},
        %Embed{resource: "rad:episode", embed: [episode1, episode2]}
      ]
    }

    assert format(Jason.encode!(document)) == format(~S(
      {
        "_embedded": {
          "rad:podcast": { "id": 18 },
          "rad:episode": [{ "id": 81 }, { "id": 82 }]
         },
         "title": "Example"
      }
    ))
  end

  defp format(json) when is_binary(json) do
    json
    |> Jason.decode!()
    |> Jason.encode!()
  end

  defp format(json) do
    format(Jason.encode!(json))
  end
end
