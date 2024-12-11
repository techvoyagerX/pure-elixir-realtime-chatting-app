defmodule TCP do
  defmacro __using__(_opts) do
    quote do
      defp send_message(socket, message) do
        :gen_tcp.send(socket, message)
      end

      defp receive_response(socket) do
        case :gen_tcp.recv(socket, 0) do
          {:ok, data} ->
            IO.puts(data)
          {:error, :closed} ->
            IO.puts("Connection closed by server")
          {:error, reason} ->
            IO.puts("Failed to receive response: #{reason}")
        end
        receive_response(socket)
      end

      defp connect(host, port) do
        case :gen_tcp.connect(host, port, [:binary, active: false]) do
          {:ok, socket} ->
            send_message(socket, "")
            socket
          {:error, reason} ->
            IO.puts("Failed to connet: #{reason}")
        end
      end
    end
  end
end
