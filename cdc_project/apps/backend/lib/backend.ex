defmodule Backend do
  use GenServer
  require Storage


  def start() do
    {:ok, backend} = GenServer.start_link(__MODULE__, :ok)
    Process.register(backend, :backend)
  end

  def stop() do
    GenServer.stop(:backend)
    # Process.unregister(:backend)
  end

  def create_nodes() do
    GenServer.call(:backend, {:create, :a})
    GenServer.call(:backend, {:create, :b})
    GenServer.call(:backend, {:create, :c})
  end

  def stop_nodes() do
    GenServer.cast(:backend, {:stop})
  end

  def get() do
    GenServer.call(:backend, {:get, :all})
  end

  def get(key) do
    GenServer.call(:backend, {:get, key})
  end

  def post(user_name, is_owner, permissions) do
    GenServer.call(:backend, {:post, user_name, is_owner, permissions})
  end

  @impl true
  def init(:ok) do
    nodes = %{}
    refs = %{}
    {:ok, {nodes, refs}}
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
  def handle_call({:get, key}, _from, {nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {nodes, refs}}
    else
      {_name, node} = Enum.random(nodes)
      res = Storage.get(node, key)
      {:reply, res, {nodes, refs}}
    end
  end

  def handle_call({:post, use_name, is_owner, permissions}, _from, {nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {nodes, refs}}
    else
      Enum.each(nodes,fn {_name, node} -> Storage.post(node, use_name, is_owner, permissions) end)
      {:reply, :ok, {nodes, refs}}
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
  def handle_call({:update}, _from, {nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {nodes, refs}}
    else
      Enum.each(nodes,fn {_name, node} -> Storage.update(node) end)
      {:reply, :ok, {nodes, refs}}
    end
  end

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
