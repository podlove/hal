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

  @spec add_link(HAL.Document.t(), HAL.Link.t()) :: HAL.Document.t()
  def add_link(document, link) do
    links =
      case document.links do
        nil -> [link]
        links when is_list(links) -> [link | links]
      end

    Map.put(document, :links, links)
  end

  defmodule MapConverter do
    def convert_properties(map, nil) do
      map
    end

    def convert_properties(map, properties) do
      for {key, val} <- properties, into: map, do: {key, val}
    end

    def convert_links(map, nil) do
      map
    end

    def convert_links(map, links) do
      data =
        links
        |> Enum.map(fn link -> {link.rel, %{href: link.href} |> add_link_title(link.title)} end)
        |> Enum.into(%{})

      Map.put(map, "_links", data)
    end

    def add_link_title(link, nil), do: link
    def add_link_title(link, title), do: Map.put(link, :title, title)

    def convert_embeds(map, nil) do
      map
    end

    def convert_embeds(map, embeds) do
      data =
        embeds
        |> Enum.map(fn embed -> {embed.resource, embed.embed} end)
        |> Enum.into(%{})

      Map.put(map, "_embedded", data)
    end
  end

  def to_map(%HAL.Document{} = document) do
    %{}
    |> MapConverter.convert_properties(document.properties)
    |> MapConverter.convert_links(document.links)
    |> MapConverter.convert_embeds(document.embeds)
  end
end
