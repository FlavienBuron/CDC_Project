defmodule Backend do
  use GenServer
  require Storage


  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: Backend)
    # Process.register(backend, :backend)
    # create_nodes()
  end

  def stop() do
    stop_nodes()
    # Process.sleep(100)
    GenServer.stop(Backend)
    # Process.unregister(:backend)

  end

  def create_nodes() do
    GenServer.call(Backend, {:create, :a})
    GenServer.call(Backend, {:create, :b})
    GenServer.call(Backend, {:create, :c})
  end

  def stop_nodes() do
    GenServer.cast(Backend, {:stop})
  end

  def get() do
    GenServer.call(Backend, {:get, :all})
  end

  def get(filename) do
    GenServer.call(Backend, {:get, filename})
  end

  def get(filename, key) do
    GenServer.call(Backend, {:get, filename, key})
  end

  def post(filename, user) do
    GenServer.call(Backend, {:post, filename, user})
  end

  def update(filename, user_name, is_owner, permissions) do
    GenServer.call(Backend, {:update, filename, user_name, is_owner, permissions})
  end

  def update(filename) do
    GenServer.call(Backend, {:update, filename})
  end

  @impl true
  def init(_init_args) do
    nodes = %{}
    refs = %{}
    {:ok, {nodes, refs}}
  end

  @impl true
  def terminate(_reason, _state) do
    :ok
  end

  @impl true
  def handle_call({:lookup, name}, _from, state) do
    {nodes, _} = state
    {:reply, Map.fetch(nodes, name), state}
  end

  @impl true
  def handle_call({:get, :all}, _from, {nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {nodes, refs}}
    else
      {_name, node} = Enum.random(nodes)
      res = Storage.get(node)
      {:reply, res, {nodes, refs}}
    end
  end

  @impl true
  def handle_call({:get, filename}, _from, {nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {nodes, refs}}
    else
      {_name, node} = Enum.random(nodes)
      res = Storage.get(node, filename)
      {:reply, res, {nodes, refs}}
    end
  end

  @impl true
  def handle_call({:get, filename, key}, _from, {nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {nodes, refs}}
    else
      {_name, node} = Enum.random(nodes)
      res = Storage.get(node, filename, key)
      {:reply, res, {nodes, refs}}
    end
  end

  @impl true
  def handle_call({:create, name}, _from, {nodes, refs}) do
    if Map.has_key?(nodes, name) do
      {:reply, "Node already exists", {nodes, refs}}
    else
      {:ok, node} = Storage.start(name)
      ref = Process.monitor(node)
      refs = Map.put(refs, ref, name)
      nodes = Map.put(nodes, name, node)
      {:reply,:ok, {nodes, refs}}
    end
  end

  @impl true
  def handle_call({:post, filename, user}, _from, {nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {nodes, refs}}
    else
      Enum.each(nodes,fn {_name, node} -> Storage.post(node, filename, user) end)
      {:reply, :ok, {nodes, refs}}
    end
  end

  @impl true
  def handle_call({:update, filename}, _from, {nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {nodes, refs}}
    else
      Enum.each(nodes,fn {_name, node} -> Storage.update(node, filename) end)
      {:reply, :ok, {nodes, refs}}
    end
  end

  def handle_call({:update, filename, use_name, is_owner, permissions}, _from, {nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {nodes, refs}}
    else
      Enum.each(nodes,fn {_name, node} -> Storage.update(node, filename, use_name, is_owner, permissions) end)
      {:reply, :ok, {nodes, refs}}
    end
  end

  # @impl true
  # def handle_call({:update, filename}, _from, {nodes, refs}) do
  #   if Enum.empty?(nodes) do
  #     {:reply, "No node available", {nodes, refs}}
  #   else
  #     Enum.each(nodes,fn {_name, node} -> Storage.update(node, filename) end)
  #     {:reply, :ok, {nodes, refs}}
  #   end
  # end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {nodes, refs}) do
    require Logger
    {name, refs} = Map.pop(refs, ref)
    Logger.debug("Node down: #{inspect(name)}")
    nodes = Map.delete(nodes, name)
    {:noreply, {nodes, refs}}
  end

  @impl true
  def handle_info(msg, state) do
    require Logger
    Logger.debug("Unexpected message in Backend: #{inspect(msg)}")
    {:noreply, state}
  end

  @impl true
  def handle_cast({:stop}, {nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {nodes, refs}}
    else
      Enum.each(nodes,fn {_name, node} -> Storage.stop(node) end)
      {:noreply, {nodes, refs}}
    end
  end
end
