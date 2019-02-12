defmodule HAL.Document do
  defimpl Jason.Encoder, for: HAL.Document do
    def encode(value, opts) do
      Jason.Encode.map(HAL.Document.to_map(value), opts)
    end
  end

  defstruct [:embeds, :links, :properties]

  @type t :: %__MODULE__{
          embeds: [HAL.Embed.t()] | nil,
          links: [HAL.Link.t()] | nil,
          properties: map() | nil
        }

  def to_map(%HAL.Document{} = document) do
    %{}
    |> add_properties(document.properties)
    |> add_links(document.links)
    |> add_embeds(document.embeds)
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

  defp add_embeds(map, nil) do
    map
  end

  defp add_embeds(map, embeds) do
    data =
      embeds
      |> Enum.map(fn embed -> {embed.resource, embed.embed} end)
      |> Enum.into(%{})

    Map.put(map, "_embedded", data)
  end
end
