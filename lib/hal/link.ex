defmodule HAL.Link do
  defstruct [:rel, :href, :title]
  @type t :: %__MODULE__{rel: String.t() | nil, href: String.t() | nil, title: String.t() | nil}
end
