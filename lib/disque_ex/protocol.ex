defmodule DisqueEx.Protocol do
  @moduledoc """
  Builds commands by taking arguments and options
  """

  @spec addjob(String.t, String.t, integer, Keyword.t) :: [String.t]
  @doc """
  Builds addjob command
  """
  def addjob(queue_name, job, timeout, []) when is_binary(job) do
    ["ADDJOB", queue_name, job, to_string(timeout)]
  end

  def addjob(queue_name, job, timeout, opts) when is_list(opts) do
    main_cmd = ["ADDJOB", queue_name, job, to_string(timeout)]
    opts
    |> Enum.reduce(main_cmd, &build_addjob_command/2)
  end

  @spec getjob([String.t], Keyword.t) :: [String.t]
  @doc """
  Builds getjob command
  """
  def getjob(queues, []) when is_list(queues) do
    ["GETJOB", "FROM"] ++ queues
  end

  def getjob(queues, opts) when is_list(queues) do
    cmd = ["GETJOB"]
    main_cmd = opts
    |> Enum.reduce(cmd, &build_getjob_command/2)

    main_cmd ++ ["FROM"] ++ queues
  end


  ## HELPER Functions

  # Builds command by reading each option
  defp build_addjob_command({:replicate, repl_count}, main_cmd)
                                      when is_integer(repl_count) do
    main_cmd ++ ["REPLICATE", to_string(repl_count)]
  end

  defp build_addjob_command({:delay, delay}, main_cmd)
                                      when is_integer(delay) do
    main_cmd ++ ["DELAY", to_string(delay)]
  end

  defp build_addjob_command({:retry, retry}, main_cmd)
                                      when is_integer(retry) do
    main_cmd ++ ["RETRY", to_string(retry)]
  end

  defp build_addjob_command({:ttl, ttl}, main_cmd)
                                      when is_integer(ttl) do
    main_cmd ++ ["TTL", to_string(ttl)]
  end

  defp build_addjob_command({:maxlen, maxlen}, main_cmd)
                                      when is_integer(maxlen)  do
    main_cmd ++ ["MAXLEN", to_string(maxlen)]
  end

  defp build_addjob_command({:async, async}, main_cmd)
                                      when is_boolean(async) do
    case async do
      true -> main_cmd ++ ["ASYNC"]
      false -> main_cmd
    end
  end

  # Builds get job command
  defp build_getjob_command({:nohang, nohang}, main_cmd) when is_boolean(nohang) do
    case nohang do
      true -> main_cmd ++ ["NOHANG"]
      false -> main_cmd
    end
  end

  defp build_getjob_command({:withcounters, withcounters}, main_cmd) when is_boolean(withcounters) do
    case withcounters do
      true -> main_cmd ++ ["WITHCOUNTERS"]
      false -> main_cmd
    end
  end

  defp build_getjob_command({:timeout, timeout}, main_cmd) when is_integer(timeout) do
    main_cmd ++ ["TIMEOUT", to_string(timeout)]
  end

  defp build_getjob_command({:count, count}, main_cmd) when is_integer(count) do
    main_cmd ++ ["COUNT", to_string(count)]
  end

end