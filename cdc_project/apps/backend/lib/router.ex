defmodule Backend.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger


  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)
  plug(CORSPlug, origin: ["http://0.0.0.0:3000"])
  plug(:dispatch)


  get "/health" do
    send_resp(conn, 200, "ok")
  end

  get "/api/getFilesTest" do
    conn
    |> put_resp_content_type("application/json")
    #|> send_resp(200, Jason.encode!(%{"age" => 44, "name" => "Marc Irwin", "nationality" => "Australian"}))
    |> send_resp(200, Jason.encode!(%{"modified_on"=> "2021-11-30 15:53:24","filename"=> "test.txt","created_on"=> "2021-11-28 12:00:00","created_by"=> "alice"}))
  end

  get "/api/getFiles" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(Backend.get()))
    end

  match _ do
    send_resp(conn, 404, "not found")
  end

end
