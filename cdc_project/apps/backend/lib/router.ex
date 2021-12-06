defmodule Backend.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger
  import FileList


  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Poison)
  plug(CORSPlug, origin: ["http://0.0.0.0:3000"])
  plug(:dispatch)



  get "/health" do
    send_resp(conn, 200, "ok")
  end

  get "/api/getFilesTest" do
    testData = ~s({"size":3,"files":[{"users":[{"user":"alice","permissions":7,"owner":true},{"user":"bob","permissions":1,"owner":false}],"modified_on":"2021-11-30 15:53:24","filename":"test.txt","created_on":"2021-11-28 12:00:00","created_by":"alice"},{"users":[{"user":"bob","permissions":7,"owner":true},{"user":"alice","permissions":4,"owner":false}],"modified_on":"2021-11-30 15:53:24","filename":"How to train your Computer.pdf","created_on":"2021-11-30 15:53:24","created_by":"bob"},{"users":[{"user":"charles","permissions":7,"owner":true}],"modified_on":"2021-12-02 10:52:31","filename":"rickroll.gif","created_on":"2021-12-02 10:52:31","created_by":"charles"}]})
    conn
    |> put_resp_content_type("application/json")
    #|> send_resp(200, Jason.encode!(%{"age" => 44, "name" => "Marc Irwin", "nationality" => "Australian"}))
    |> send_resp(200, testData)
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
