defmodule HALTest do
  use ExUnit.Case
  doctest HAL

  alias HAL.Document
  alias HAL.Link

  test "renders empty document" do
    assert Document.render(%Document{}) == "{}"
  end

  test "renders properties" do
    document = %HAL.Document{properties: %{foo: 42, bar: "baz"}}

    assert Document.render(document) == format(~S({"foo": 42, "bar": "baz"}))
  end

  test "renders links" do
    document = %HAL.Document{
      links: [
        %Link{rel: "self", href: "/foo"},
        %Link{rel: "next", href: "/foo?page=2", title: "Page 2"}
      ]
    }

    assert Document.render(document) ==
             format(~S({
               "_links": {
                 "self": { "href": "/foo" },
                 "next": { "href": "/foo?page=2", "title": "Page 2"}
                }
             }))
  end

  defp format(json) do
    json
    |> Jason.decode!()
    |> Jason.encode!()
  end
end
