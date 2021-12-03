defmodule Backend.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_init_args) do
    children = [
      Backend,
      {Task.Supervisor, name: Backend.TaskSupervisor}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
