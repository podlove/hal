defmodule HAL.Embed do
  defstruct [:resource, :embed]
  @type t :: %__MODULE__{resource: String.t(), embed: HAL.Document.t() | [HAL.Document.t()]}
end
