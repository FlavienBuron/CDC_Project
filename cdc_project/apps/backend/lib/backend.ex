defmodule Backend do

  def start do
    IO.puts("Creating backend...")
    Process.register(spawn(__MODULE__, :listen, []), :backend)
  end

  def listen() do
    receive do
      {:get, msg} ->
        IO.inspect(msg)
        listen()
      {:put, msg} ->
        IO.inspect(msg)
        listen()
      {:update, msg} ->
        IO.inspect(msg)
        listen()
      :stop ->
        :stop
    end
  end

  def get(key) do
    send(:a, {:get, key})
    :ok
  end

  def get_all() do
    send(:a, {:get, :all})
    :ok
  end

  def put(user_name, is_owner, permissions) do
    for n <- [:a, :b, :c], do: send(n, {:put, {user_name, is_owner, permissions}})
    :ok
  end

  def stop() do
    send(:backend, :stop)
  end

  def update() do
    for n <- [:a, :b, :c], do: send(n, {:update})
  end
end
