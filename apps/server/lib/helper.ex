defmodule Parser do
  defmacro __using__(_opts) do
    quote do
      def parse_request({"create", name, socket}) do
        {:create, name, socket}
      end

      def parse_request({"join", name, socket}) do
        {:join, name, socket}
      end

      def parse_request({"delete", name}) do
        {:delete, name}
      end

      def parse_request({"send", msg}) do
        {:send, msg}
      end
    end
  end
end
