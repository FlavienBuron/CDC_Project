defmodule StorageTest do
  use ExUnit.Case
  doctest Storage

  test "Create nodes" do
    assert Storage.start() == :ok
  end

  test "Stop nodes" do
    assert Storage.stop() == [:stop, :stop, :stop]
  end
end
