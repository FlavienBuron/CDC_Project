defmodule Storage do
  import StorageFile
  use Agent

  def start(name) do
    node = Atom.to_string(name)
    Agent.start(fn -> "./apps/storage/lib/files/test_#{node}.json" end)
  end

  def get(node) do
    Agent.get(node, &get_json(&1))
  end

  def get(node, key) do
    Agent.get(node, &Map.get(get_json(&1), key))
  end

  def post(node, user_name, is_owner, permissions) do
    Agent.update(node, &add_user(&1, user_name, is_owner, permissions))
  end

  def update(node) do
    Agent.update(node, &update_time(&1))
  end

  def stop(node) do
    Agent.stop(node)
  end

  #################### Private methods ####################Gen

  defp get_json(filename) do
    with {:ok, body} <- File.read(filename) do
      Poison.decode!(body, as: %StorageFile{})
    end
  end

  defp write_json(filename, data) do
    data_json = Poison.encode!(data)
    File.write(filename, data_json)
  end

  defp add_user(filename, user_name, is_owner, permissions) do
    data = get_json(filename)
    users = data.users ++ [%User{user: user_name, owner: is_owner, permissions: permissions}]
    new_data = Map.replace!(data, :users, users)
    write_json(filename, new_data)
    filename
  end

  defp update_time(filename) do
    time = get_datetime()
    data = get_json(filename)
    new_data = Map.replace!(data, :modified_on, time)
    write_json(filename, new_data)
    filename
  end

  defp get_datetime() do
    time = DateTime.utc_now()
    str_time = Calendar.strftime(time, "%Y-%m-%d %H:%M:%S")
    str_time
  end

end
