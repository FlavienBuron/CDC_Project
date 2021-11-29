defmodule StorageFile do
  import User

  @derive [Poison.Encoder]
  defstruct [
    filename: String,
    created_on: String,
    modified_on: String,
    users: [%User{}]
  ]

  # @type t() :: %__MODULE__{
  #   filename: String.t(),
  #   created_on: String.t(),
  #   modified_on: String.t(),
  #   users: [Map.t()]
  # }
end
