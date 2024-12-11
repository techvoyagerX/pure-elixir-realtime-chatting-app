defmodule Client do
  use TCP

  defp parse_input(input) do
    [command, args] = input
                      |> String.split(" ")
    %{command: command, args: args}
  end

  defp receive_user_input(socket) do
    input = IO.gets("Please input to send message: ")
    case input do
      nil ->
        IO.puts("End of input.")
      _ ->
        args = parse_input(input)
        send_message(socket, args)
    end
    receive_user_input(socket)
  end

  def run do
    host = Application.get_env(:host, :key)
    port = Application.get_env(:port, :key)

    socket = connect(host, port)

    Task.start(fn ->
        receive_response(socket)
    end)

    receive_user_input(socket)
  end
end
