defmodule Nodes do
  import FileList
  # import User
  use GenServer

  ### File permissions ###
  # 0 = --- => no permissions
  # 1 = --x => Execute permission only
  # 2 = -w- => Write only
  # 3 = -wx => write and execute
  # 4 = r-- => read only
  # 5 = r-x => read and execute
  # 6 = rw- => read and write
  # 7 = rwx => read, write and execute



  def start_link(opts) do
    IO.inspect(node())
    GenServer.start_link(__MODULE__, opts, name: node())
  end

  @impl GenServer
  def init(_init_args) do
    json_file = "./lib/files/test_a.json"
    {:ok, json_file}
  end

  ### GET calls ###

  @impl GenServer
  def handle_info({:get, src}, state) do
    require Logger
    {_, node} = src
    Logger.info("Request for all files from #{node}")
    files = get_file(state)
    send(src, files)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({{:get, :permission, filename, username, permissions}, src}, state) do
    require Logger
    {_, node} = src
    Logger.info("Request if #{username} has permission on #{filename}")
    has_perm = has_permission(state, filename, username, permissions)
    send(src, has_perm)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({{:get, :user, name}, src}, state) do
    require Logger
    {_, node} = src
    Logger.info("Request for files of #{name}")
    files = get_user_files(state, name)
    file = Poison.encode!(files)
    send(src, file)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({{:get, :file, filename}, src}, state) do
    require Logger
    {_, node} = src
    Logger.info("Request for specific file #{filename} from #{node}")
    file = get_file(state, filename)
    {_,file} = Poison.encode(file)
    send(src, file)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({{:get, filename, key}, src}, state) do
    require Logger
    {_, node} = src
    Logger.info("Request for specific key #{key} in file #{filename} from #{node}")
    res = Map.get(get_file(state, filename), key)
    {_, value} = Poison.encode(%{key => res})
    send(src, value)
    {:noreply, state}
  end

  ### POST calls ###

  @impl GenServer
  def handle_info({{:post, filename, user_name}, src}, state) do
    require Logger
    {_, node} = src
    Logger.info("Post new file #{filename} by #{user_name} from #{node}")
    file = add_file(state, filename, user_name)
    send(src, file)
    {:noreply, state}
  end

  ### UPDATE calls ###

  @impl GenServer
  def handle_info({{:update, filename, user_name, is_owner, permissions}, src}, state) do
    require Logger
    {_, node} = src
    Logger.info("Update new user #{user_name} #{is_owner} #{permissions} to file #{filename} from #{node}")
    file = add_user(state, filename, user_name, is_owner, permissions)
    send(src, file)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({{:update, filename}, src}, state) do
    require Logger
    {_, node} = src
    Logger.info("Update file #{filename} from #{node}")
    file = update_time(state, filename)
    send(src, file)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:stop}, state) do
    require Logger
    # {_, node} = src
    Logger.info("Request for shutdown")
    GenServer.stop(node())
    {:noreply, state}
  end

  #################### Private methods ####################Gen

  defp get_file(file) do
    with {:ok, body} <- File.read(file) do
      body
    end
  end

  defp get_file(json_file, filename) do
    data = get_json(json_file)
    file = Enum.find(data.files, fn file ->
      file.filename == filename
    end)
    file
  end

  def get_user_files(json_file, user_name) do
    data = get_json(json_file)
    files = Enum.filter(data.files, fn file ->
      userlist = file.users
      res = Enum.map(userlist, fn user ->
        username = Map.get(user, "user")
        cond do
        username == user_name ->
          true
        true -> false
        end
      end)
      if Enum.any?(res) do
        file
      end
    end)
    %FileList{files: files, size: length(files)}
    # user_files
  end

  def get_json(json_file) do
    with {:ok, body} <- File.read(json_file) do
      Poison.decode!(body, as: %FileList{})
    end
  end

  defp write_json(json_file, data) do
    data_json = Poison.encode!(data)
    File.write(json_file, data_json)
    data_json
  end

  defp add_user(json_file, filename, user_name, is_owner, permissions) do
    data = get_json(json_file)
    files = Enum.map(data.files, fn file ->
      cond do
        file.filename == filename ->
          users = file.users ++ [%User{user: user_name, owner: is_owner, permissions: permissions}]
          Map.replace!(file, :users, users)
        true -> file
      end
    end)
    new_data = Map.replace!(data, :files, files)
    write_json(json_file, new_data)
    # files
  end

  defp update_time(json_file, filename) do
    time = get_datetime()
    data = get_json(json_file)
    files = Enum.map(data.files, fn file ->
      cond do
        file.filename == filename -> Map.replace!(file, :modified_on, time)
        true -> file
      end
    end)
    new_data = Map.replace!(data, :files, files)
    write_json(json_file, new_data)
    # files
  end

  defp get_datetime() do
    time = DateTime.utc_now()
    str_time = Calendar.strftime(time, "%Y-%m-%d %H:%M:%S")
    str_time
  end

  defp add_file(json_file, filename, user_name) do
    data = get_json(json_file)
    date = get_datetime()
    new_file = %FileTemplate{filename: filename,
                created_by: user_name,
                created_on: date,
                modified_on: date,
                users: [%User{:user => user_name, :owner => true, :permissions => 7}]
                }
    files = data.files ++ [new_file]
    size = length(files)
    new_data = Map.replace!(data, :files, files)
    new_data = Map.replace!(new_data, :size, size)
    write_json(json_file, new_data)
    # files
  end

  def has_permission(json_file, filename, username, permissions) do
    data = get_user_files(json_file, username)
    files = Enum.filter(data.files, fn file ->
      file.filename == filename
    end)
    perm = Enum.any?(files, fn file ->
      userlist = file.users
      cond do
        file.created_by == username ->
          true
        true ->
          Enum.any?(Enum.map(userlist, fn user ->
            file_user = Map.get(user, "user")
            cond do
              file_user == username ->
                Enum.member?(permissions, Map.get(user, "permissions"))
              true -> false
            end
          end))
      end
    end)
    perm

  end
  # # def get_dist(backend, node) do

  # # end

  # # defp remote_supervisor()






end
