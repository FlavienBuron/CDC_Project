defmodule Backend.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger
  import FileList

  @moduledoc """
  This is the module for the backend rest server. It present a 'client' endpoints that can be called via http
  """

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Poison)
  plug(CORSPlug, origin: ["http://0.0.0.0:3000"])
  plug(:dispatch)

  ## CHECK HEALTH ##

  get "/health" do
    send_resp(conn, 200, "ok")
  end

  ## MANAGE NODES ##

  get "/api/stopNodes" do
    queryResult = Backend.stop_nodes()
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(queryResult))
  end

  ## GET / UPDATE SPECIFIC FILE ##

  get "/api/files/:filename" do
    queryResult = Backend.get_files(filename)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(queryResult))
  end

  get "/api/files/users/:user" do
    queryResult = Backend.get_files(user)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(queryResult))
  end

  ## update file
  patch "/api/files/:filename/users/:user" do
      queryResult = Backend.update(filename, user)
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, queryResult)
  end

  ## GET ALL FILES ##

  get "/api/files" do
    queryResult = Backend.get()
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(queryResult))
    end

  get "/api/files/users" do
    queryResult = Backend.get()
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(queryResult))
  end

  ## POST A NEW FILE ##

  post "/api/files" do
    username =
      case conn.body_params do
        %{"username" => a_name } -> a_name
        _ -> ""
      end

    filename =
      case conn.body_params do
        %{"filename" => b_name } -> b_name
        _ -> ""
      end

    queryResult = Backend.post(filename,username)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(queryResult))
  end

  patch "/api/files" do
    by_username =
      case conn.body_params do
        %{"username" => a_name } -> a_name
        _ -> ""
      end

    filename =
      case conn.body_params do
        %{"filename" => b_name } -> b_name
        _ -> ""
      end

    new_username =
      case conn.body_params do
        %{"filename" => b_name } -> b_name
        _ -> ""
      end

    is_owner =
      case conn.body_params do
        %{"filename" => b_name } -> b_name
        _ -> ""
      end

    permissions =
      case conn.body_params do
        %{"filename" => b_name } -> b_name
        _ -> ""
      end

    queryResult = Backend.update(filename, by_username, new_username, is_owner, permissions)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!("file posted"))
  end

  ## DEFAULT ENDPOINT ##

  match _ do
    send_resp(conn, 404, "not found")
  end

end
