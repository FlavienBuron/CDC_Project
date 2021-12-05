defmodule Nodes.Application do
  use Application

  def start(_start_type, _start_args) do
    children = [
      Nodes
      # {Task.Supervisor, name: Nodes.Task}
    ]
    opts = [strategy: :one_for_one, name: Nodes.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
