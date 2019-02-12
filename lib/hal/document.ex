defmodule HAL.Document do
  defstruct [:embeds, :links, :properties]

  def render(document) do
    %{}
    |> add_properties(document.properties)
    |> add_links(document.links)
    |> Jason.encode!()
  end

  defp add_properties(map, nil) do
    map
  end

  defp add_properties(map, properties) do
    for {key, val} <- properties, into: map, do: {key, val}
  end

  defp add_links(map, nil) do
    map
  end

  defp add_links(map, links) do
    data =
      links
      |> Enum.map(fn link -> {link.rel, %{href: link.href} |> add_link_title(link.title)} end)
      |> Enum.into(%{})

    Map.put(map, "_links", data)
  end

  defp add_link_title(link, nil), do: link
  defp add_link_title(link, title), do: Map.put(link, :title, title)
end
