defmodule FileTemplate do
  import User

  @derive [Poison.Encoder]
  defstruct [
    filename: nil,
    created_by: nil,
    created_on: nil,
    modified_on: nil,
    users: nil
  ]

  @type t() :: %FileTemplate{
    filename: String.t(),
    created_by: String.t(),
    created_on: String.t(),
    modified_on: String.t(),
    users: [%User{}]
  }

end
