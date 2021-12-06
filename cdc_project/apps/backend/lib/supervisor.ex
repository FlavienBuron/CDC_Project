defmodule Backend.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_init_args) do
    children = [
      Backend,
      Plug.Cowboy.child_spec(scheme: :http,plug: Backend.Router,options: [ip: {0,0,0,0}, port: 8080]),
      {Task.Supervisor, name: Backend.TaskSupervisor}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
