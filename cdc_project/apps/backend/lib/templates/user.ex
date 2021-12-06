defmodule User do

  @derive [Poison.Encoder]
  defstruct [
    user: nil,
    owner: nil,
    permissions: nil
  ]

  @type t() :: %User{
    user: String.t(),
    owner: boolean(),
    permissions: integer()
  }

end
