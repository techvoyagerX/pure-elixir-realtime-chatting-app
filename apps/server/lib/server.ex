defmodule Server do
  use Application

  @impl true
  def run do
    host = Application.get_env(:host, :key)
    port = Application.get_env(:host, :key)

    children = [
      {Socket, {host, port}},
      {DynamicSupervisor, name: Room.Supervisor}
    ]

    opts = [strategy: :one_for_one, name: Server.Supervisior]
    Supervisor.start_link(children, opts)
  end
end
