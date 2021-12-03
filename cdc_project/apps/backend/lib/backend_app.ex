defmodule BackendApp do
  use Application

  @impl true
  def start(_type, _args) do
    Backend.Supervisor.start_link(name: Backend.Supervisor)
  end

end
