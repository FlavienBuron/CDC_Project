defmodule Storage do
# import Poison

  def deploy() do
    IO.puts("Creating processes...")
    Process.register(spawn(__MODULE__, :listen, ["./lib/test_a.json"]), :a)
    Process.register(spawn(__MODULE__, :listen, ["./lib/test_b.json"]), :b)
    Process.register(spawn(__MODULE__, :listen, ["./lib/test_c.json"]), :c)
    IO.puts("Processes created...")
  end

  def listen(json) do
    receive do
      {:get, {:all, caller}} ->
        map = get_json(json)
        send(caller, Map.to_list(map))
        listen(json)
      {:get, {key, caller}} ->
        map = get_json(json)
        send(caller, Map.get(map, key))
        listen(json)
      {:put, {key, value}} ->
        :ok
        # listen(Map.put(map, key, value))
      :stop ->
        :stop
    end
  end

  def get_json(filename) do
    with {:ok, body} <- File.read(filename) do
      Poison.decode!(body)
    end
  end

  def get(key) do
    IO.puts("Getting ...")
    for n <- [:a, :b, :c], do: send(n, {:get, {key, self()}})
  end

  def get_all() do
    IO.puts("Getting all...")
    send(:a, {:get, {:all, self()}})
  end

  def put(key, value) do
    IO.puts("Putting ...")
    for n <- [:a, :b, :c], do: send(n, {:put, {key, value}})
  end

  def start() do
    IO.puts("Deploying...")
    deploy()
    IO.puts("Ready...")
    # Process.unregister(:a)
  end

  def stop() do
    for n <- [:a, :b, :c], do: send(n, :stop)
  end

end
