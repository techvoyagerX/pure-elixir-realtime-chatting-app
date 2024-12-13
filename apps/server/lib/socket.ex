defmodule Socket do
  use Parser

  def start_link(opts) do
    Task.start_link(__MODULE__, fn -> run(opts) end)
  end

  def run({host, port}) do
    opts = [:binary, {:packet, 0}, {:active, false}, {:reuseaddr, true}]
    {:ok, listener} = :gen_tcp.listen({host, port}, opts)
    accept(listener)
  end

  def receiver(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, request} ->
        {command, name, socket} = parse_request(request)
        GenServer.call(Registry, {command, name, socket})
      {:error, reason} ->
        IO.puts("Error occured while receving: #{reason}")
    end
  end

  def accept(listener) do
    {:ok, socket} = :gen_tcp.accept(listener)
    receiver(socket)
    accept(listener)
  end
end
