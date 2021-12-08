defmodule Backend do
  use GenServer

  @moduledoc """
  This is the module for the backend logic. It present a 'client' API, as set of call that are then appropriatelly directed to the nodes
  """


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

  @doc """
  Retrieve the entirety of the files present in the nodes
  """
  def get() do
    GenServer.call(node(), {:get, :all})
  end

  @doc """
  Retrieve the files for which the specified user has access to.
  Only files where the user is in the user list
  """
  def get(user) do
    GenServer.call(node(), {:get, :user, user})
  end

  @doc """
  Retrieve the specified file regardless of the user.
  """
  def get(filename) do
    GenServer.call(node(), {:get, :file, filename})
  end

  @doc """
  Retrieve the specified key from the file regardless of the user.
  """
  def get(filename, key) do
    GenServer.call(node(), {:get, filename, key})
  end

  @doc """
  Create a new file owned by the user
  """
  def post(filename, user) do
    GenServer.call(node(), {:post, filename, user})
  end

  @doc """
  Add a user to the file with ownership status and permissions
  Only users with ownership can add new user
  """
  def update(filename, user_name, is_owner, permissions) do
    GenServer.call(node(), {:update, filename, user_name, is_owner, permissions})
  end

  @doc """
  Update the "modified_on" timestamp of the file, to simulate a write.
  Only users with write access can update
  """
  def update(filename, username) do
    GenServer.call(node(), {:update, filename, username})
  end

  defp check_permissions(filename, username, permissions) do
    GenServer.call(node(), {:get, :permission, filename, username, permissions})
  end

  @impl true
  def init(_init_args) do
    self = {node(), node()}
    node1 = {:node1@node1, :node1@node1}
    node2 = {:node2@node2, :node2@node2}
    node3 = {:node3@node3, :node3@node3}
    nodes = %{node1: node1, node2: node2, node3: node3}
    Process.sleep(300)
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
  def handle_call({:get, :user, name}, _from, {self, nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {self, nodes, refs}}
    else
      {_name, node} = Enum.random(nodes)
      send(node, {{:get, :user, name}, self})
      receive do
        msg ->
          {:reply, msg, {self, nodes, refs}}
      end
    end
  end

  @impl true
  def handle_call({:get, :file, filename}, _from, {self, nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {self, nodes, refs}}
    else
      {_name, node} = Enum.random(nodes)
      send(node, {{:get, :file, filename}, self})
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

  @impl true
  def handle_call({:get, :permission, filename, username, permissions}, _from, {self, nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {self, nodes, refs}}
    else
      {_name, node} = Enum.random(nodes)
      send(node, {{:get, :permission, filename, username, permissions}, self})
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

  ### UPDATE calls ###

  @impl true
  def handle_call({:update, filename, username}, _from, {self, nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {self, nodes, refs}}
    else
      perm = has_permission(nodes, filename, username, [2, 3, 6, 7])
      if perm do
        IO.inspect(perm)
        Enum.each(nodes,fn {_name, node} ->
          send(node, {{:update, filename}, self})
        end)
        msg = listen(3)
        {:reply, msg, {self, nodes, refs}}
      else
        IO.inspect(perm)
        msg = "{\"ok\"}"
        {:reply, msg, {self, nodes, refs}}
      end
    end
  end

  def has_permission(nodes, filename, username, permissions) do
    {_name, node} = Enum.random(nodes)
    send(node, {{:get, :permission, filename, username, permissions}, self})
    receive do
      msg ->
        msg
    end
  end

  def handle_call({:update, filename, user_name, is_owner, permissions}, _from, {self, nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {self, nodes, refs}}
    else
      if is_owner do
        permissions = 7
      end
      Enum.each(nodes,fn {_name, node} ->
        send(node, {{:update, filename, user_name, is_owner, permissions}, self})
      end)
      msg = listen(3)
      {:reply, msg, {self, nodes, refs}}
    end
  end

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
  def handle_cast({:stop}, {self, nodes, refs}) do
    if Enum.empty?(nodes) do
      {:reply, "No node available", {self, nodes, refs}}
    else
      Enum.each(nodes,fn {_name, node} ->
        send(node, {:stop})
      end)
      {:noreply, {self, nodes, refs}}
    end
  end

  ### Helper functions
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


end
