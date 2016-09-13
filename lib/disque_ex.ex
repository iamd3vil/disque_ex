defmodule DisqueEx do
  @moduledoc """
  `DisqueEx` provides an Elixir api for `Disque` message queue. This module
  contains all the API functions. 

  Note: DisqueEx uses Redix as the underlying library for interaction with the disque server
  """

  @type queue :: String.t

  @type message :: String.t

  @type job_id :: String.t

  @type job :: [String.t]

  @doc """
  Starts the connection
  """
  def start_link() do
    Redix.start_link(host: "localhost", port: 7711)
  end

  def start_link(opts) when is_list(opts) do
    Redix.start_link(opts)
  end

  def info(conn) do
    Redix.command(conn, ["INFO"])
  end

  @spec addjob(pid, queue, message, integer, Keyword.t) :: {:ok, job_id} | {:error, String.t}
  @doc """
  Adds job and returns job id
  """
  def addjob(conn, queue_name, message, timeout \\ 0, opts \\ []) do
    DisqueEx.Protocol.addjob(queue_name, message, timeout, opts)
    |> command(conn)
  end

  @spec getjob(pid, [String.t], Keyword.t) :: {:ok, [job] | nil}
  @doc """
  Gets jobs from the given list of queues
  """
  def getjob(conn, queues, opts \\ []) do
    cmd = DisqueEx.Protocol.getjob(queues, opts)
    opts
    |> Keyword.get(:timeout)
    |> case do
         nil -> Redix.command(conn, cmd, timeout: :infinity)
         timeout -> Redix.command(conn, cmd, timeout: timeout)
    end
  end

  @spec ackjob(pid, [job_id]) :: {:ok, integer} | {:error, String.t}
  @doc """
  Acknowledges given list of job ids
  """
  def ackjob(conn, job_ids) when is_list(job_ids) do
    DisqueEx.Protocol.ack(job_ids)
    |> command(conn)
  end

  @spec fastack(pid, [job_id]) :: {:ok, integer} | {:error, String.t}
  @doc """
  Fast acknowledges given list of jobs. This is equivalent to `ackjob/2` but much 
  faster (due to less messages being exchanged), 
  however during failures it is more likely that fast acknowledges will 
  result in multiple deliveries of the same messages.
  """
  def fastack(conn, job_ids) when is_list(job_ids) do
    DisqueEx.Protocol.fastack(job_ids)
    |> command(conn)
  end

  @spec working(pid, job_id) :: {:ok, integer} | {:error, String.t}
  @doc """
  Makes a job working, which disque server tries to postpone the delivery. Re tuns seconds which you likely postponed the job (which is basically like a retry time), under which you have to make the job working again or it will be sent.
  """
  def working(conn, job_id) when is_binary(job_id) do
    DisqueEx.Protocol.working(job_id)
    |> command(conn)
  end

  @spec nack(pid, [String.t]) :: {:ok, integer} | {:error, String.t}
  @doc """
  Requeues the job for any other consumer to pick it up.
  """
  def nack(conn, job_ids) when is_list(job_ids) do
    DisqueEx.Protocol.nack(job_ids)
    |> command(conn)
  end

  defp command(command, conn) do
    Redix.command(conn, command)
  end
end
