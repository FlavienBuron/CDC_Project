defmodule FileList do
  import FileTemplate

  @derive [Poison.Encoder]
  defstruct [
    files: [%FileTemplate{}],
    size: Integer
  ]

end
