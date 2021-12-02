defmodule BackEndAppTest do
  use ExUnit.Case
  doctest BackEndApp

  test "greets the world" do
    assert BackEndApp.hello() == :ok
  end
end
