defmodule Backend do
  use GenServer


  def start_link(opts) do
    IO.inspect(node())
    GenServer.start_link(__MODULE__, opts, name: node())
  end

  def stop() do
    GenServer.stop(node())
  end

  def stop_nodes() do
    GenServer.cast(node(), {:stop})
  end

  def get() do

    GenServer.call(node(), {:get, :all})
  end

  def get(filename) do
    GenServer.call(node(), {:get, filename})
  end

  def get(filename, key) do
    GenServer.call(node(), {:get, filename, key})
  end

  def post(filename, user) do
    GenServer.call(node(), {:post, filename, user})
  end

  def update(filename, user_name, is_owner, permissions) do
    GenServer.call(node(), {:update, filename, user_name, is_owner, permissions})
  end

  def update(filename) do
    GenServer.call(node(), {:update, filename})
  end

  @impl true
  def init(_init_args) do
    self = {node(), node()}
    Process.sleep(100)
    node1 = {:node1@node1, :node1@node1}
    node2 = {:node2@node2, :node2@node2}
    node3 = {:node3@node3, :node3@node3}
    nodes = %{node1: node1, node2: node2, node3: node3}
    ref1 = Process.monitor(node1)
    ref2 = Process.monitor(node2)
    ref3 = Process.monitor(node3)
    refs = %{ref1 => :node1, ref2 => :node2, ref3 => :node3}
    {:ok, {self, nodes, refs}}
  end

  @impl true
  def terminate(_reason, _state) do
    :ok
  end

  ### GET calls ###

  @impl true
  def handle_call({:get, :all}, _from, {self, nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {self, nodes, refs}}
    else
      {_name, node} = Enum.random(nodes)
      send(node, {:get, self})
      receive do
        msg ->
          {:reply, msg, {self, nodes, refs}}
      end
    end
  end

  @impl true
  def handle_call({:get, filename}, _from, {self, nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {self, nodes, refs}}
    else
      {_name, node} = Enum.random(nodes)
      send(node, {{:get, filename}, self})
      receive do
        msg ->
          {:reply, msg, {self, nodes, refs}}
      end
    end
  end

  @impl true
  def handle_call({:get, filename, key}, _from, {self, nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {self, nodes, refs}}
    else
      {_name, node} = Enum.random(nodes)
      send(node, {{:get, filename, key}, self})
      receive do
        msg ->
          {:reply, msg, {self, nodes, refs}}
      end
    end
  end

  ### POST calls ###

  @impl true
  def handle_call({:post, filename, user}, _from, {self, nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {self, nodes, refs}}
    else
      Enum.each(nodes,fn {_name, node} ->
        send(node, {{:post, filename, user}, self})
      end)
      msg = listen(3)
      {:reply, msg, {self, nodes, refs}}
      # receive do
      #   msg ->
      #     {:reply, msg, {self, nodes, refs}}
      # end
    end
  end

  defp listen(1) do
    receive do
      msg ->
        msg
    end
  end

  defp listen(n) do
    receive do
      msg ->
        listen(n-1)
    end
  end

  ### UPDATE calls ###

  @impl true
  def handle_call({:update, filename}, _from, {self, nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {self, nodes, refs}}
    else
      Enum.each(nodes,fn {_name, node} ->
        send(node, {{:update, filename}, self})
      end)
      msg = listen(3)
      {:reply, msg, {self, nodes, refs}}
    end
  end

  def handle_call({:update, filename, user_name, is_owner, permissions}, _from, {self, nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {self, nodes, refs}}
    else
      Enum.each(nodes,fn {_name, node} ->
        send(node, {{:update, filename, user_name, is_owner, permissions}, self})
      end)
      msg = listen(3)
      {:reply, msg, {self, nodes, refs}}
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
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {self, nodes, refs}) do
    require Logger
    {name, refs} = Map.pop(refs, ref)
    Logger.debug("Node down: #{inspect(name)}")
    nodes = Map.delete(nodes, name)
    {:noreply, {self, nodes, refs}}
  end

  @impl true
  def handle_info(msg, state) do
    require Logger
    Logger.debug("Received reply from a node")
    IO.inspect(msg)
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
