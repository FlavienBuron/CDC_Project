defmodule Storage do
  import StorageFile


  def deploy() do
    IO.puts("Creating processes...")
    Process.register(spawn(__MODULE__, :listen, ["./apps/storage/lib/files/test_a.json"]), :a)
    Process.register(spawn(__MODULE__, :listen, ["./apps/storage/lib/files/test_b.json"]), :b)
    Process.register(spawn(__MODULE__, :listen, ["./apps/storage/lib/files/test_c.json"]), :c)
    IO.puts("Processes created...")
  end

  def listen(json) do
    receive do
      {:get, :all} ->
        # return the full file
        map = get_json(json)
        send(:backend, {:get, map})
        listen(json)
      {:get, key} ->
        # return value associated to key
        map = get_json(json)
        send(:backend, {:get, Map.get(map, key)})
        listen(json)
      {:put, {user_name, is_owner, permissions}} ->
        # add new user to list
        add_user(json, user_name, is_owner, permissions)
        send(:backend, {:put, "New user added"})
        listen(json)
      {:update} ->
        update(json)
        send(:backend, {:update, :ok})
        listen(json)
      :stop ->
        :stop
    end
  end

  def get_json(filename) do
    with {:ok, body} <- File.read(filename) do
      Poison.decode!(body, as: %StorageFile{})
    end
  end

  def write_json(filename, data) do
    data_json = Poison.encode!(data)
    File.write(filename, data_json)
  end

  def add_user(filename, user_name, is_owner, permissions) do
    time = get_datetime()
    data = get_json(filename)
    users = data.users ++ [%User{user: user_name, owner: is_owner, permissions: permissions}]
    new_data1 = Map.replace!(data, :users, users)
    new_data2 = Map.replace!(new_data1, :modified_on, time)
    write_json(filename, new_data2)
  end

  def update(filename) do
    time = get_datetime()
    data = get_json(filename)
    new_data = Map.replace!(data, :modified_on, time)
    write_json(filename, new_data)
  end

  def get_datetime() do
    time = DateTime.utc_now()
    str_time = Calendar.strftime(time, "%Y-%m-%d %H:%M:%S")
    str_time
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
