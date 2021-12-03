defmodule Storage do
  import FileList
  use Agent

  ### File permissions ###
  # 0 = --- => no permissions
  # 1 = --x => Execute permission only
  # 2 = -w- => Write only
  # 3 = -wx => write and execute
  # 4 = r-- => read only
  # 5 = r-x => read and execute
  # 6 = rw- => read and write
  # 7 = rwx => read, write and execute

  def start(name) do
    node = Atom.to_string(name)
    Agent.start(fn -> "./apps/storage/lib/files/test_#{node}.json" end)
  end

  ### GET calls ###

  def get(node) do
    Agent.get(node, &get_json(&1))
  end

  def get(node, filename) do
    Agent.get(node, &get_file(&1, filename))
  end

  def get(node, filename, key) do
    Agent.get(node, &Map.get(get_file(&1, filename), key))
  end

  ### POST calls ###

  def post(node, filename, user_name) do
    Agent.update(node, &add_file(&1, filename, user_name))
  end

  ### UPDATE calls ###

  def update(node, filename, user_name, is_owner, permissions) do
    Agent.update(node, &add_user(&1, filename, user_name, is_owner, permissions))
  end

  def update(node, filename) do
    Agent.update(node, &update_time(&1, filename))
  end

  ### STOP agent ###

  def stop(node) do
    Agent.stop(node)
  end

  #################### Private methods ####################Gen

  defp get_json(json_file) do
    with {:ok, body} <- File.read(json_file) do
      Poison.decode!(body, as: %FileList{})
    end
  end

  defp write_json(json_file, data) do
    data_json = Poison.encode!(data)
    File.write(json_file, data_json)
  end

  defp get_file(json_file, filename) do
    data = get_json(json_file)
    file = Enum.find(data.files, fn file ->
      file.filename == filename
    end)
    file
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
    json_file
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
    json_file
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
                users: [%User{user: user_name, owner: true, permissions: 7}]
                }
    files = data.files ++ [new_file]
    size = length(files)
    new_data = Map.replace!(data, :files, files)
    new_data = Map.replace!(new_data, :size, size)
    write_json(json_file, new_data)
  end

end
