defmodule BackEndApp.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Poison
  plug(:dispatch)

  get "/health" do
    send_resp(conn, 200, "ok")
  end

#  get "/putFiles" do
#    with :ok <- BackEndApp.start() do
#      send_resp(conn, 200, Poison.encode!("Network started successfully"))
#    end
#  end

  get "/api/putFiles" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!("Successfully inserted a file"))
  end

  get "/api/getFiles" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{BackendApp.get_all()}))
  end

  get "/api/stop" do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Poison.encode!("Successfully stopped the network"))
  end

  get "/api/update" do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Poison.encode!("Successfully updated the network"))
  end

  
  match _ do
    send_resp(conn, 404, "not found")
  end

end
