defmodule DisqueEx do
  def start_link() do
    Redix.start_link(host: "localhost", port: 7711)
  end

  def start_link(opts) when is_list(opts) do
    Redix.start_link(opts)
  end

  def info(conn) do
    Redix.command(conn, ["INFO"])
  end

  @spec addjob(pid, String.t, String.t, integer, Keyword.t) :: {:ok, String.t} | {:error, String.t}
  def addjob(conn, queue_name, message, timeout \\ 0, opts \\ []) do
    DisqueEx.Protocol.addjob(queue_name, message, timeout, opts)
    |> command(conn)
  end

  def getjob(conn, queues, opts \\ []) do
    cmd = DisqueEx.Protocol.getjob(queues, opts)
    opts
    |> Keyword.get(:timeout)
    |> case do
         nil -> Redix.command(conn, cmd, timeout: :infinity)
         timeout -> Redix.command(conn, cmd, timeout: timeout)
    end
  end

  defp command(command, conn) do
    Redix.command(conn, command)
  end
end
