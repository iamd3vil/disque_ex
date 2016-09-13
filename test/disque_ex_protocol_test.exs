defmodule DisqueExProtocolTest do
  use ExUnit.Case, async: true
  doctest DisqueEx
  alias DisqueEx.Protocol

  test "addjob protocol with empty opts" do
    queue_name = "sample_queue"
    job = "sample_job"
    timeout = 10
    assert ["ADDJOB", queue_name, job, to_string(timeout)] == Protocol.addjob(queue_name, job, timeout, [])
  end

  test "addjob protocol with opts" do
    queue_name = "sample_queue"
    job = "sample_job"
    timeout = 10
    opts = [
      {:replicate, 2},
      {:delay, 2},
      {:retry, 5},
      {:ttl, 10},
      {:maxlen, 10},
      {:async, true}
    ] # All the options
    command = [
      "ADDJOB", 
      queue_name, 
      job, 
      to_string(timeout),
      "REPLICATE", "2",
      "DELAY", "2",
      "RETRY", "5",
      "TTL", "10",
      "MAXLEN", "10",
      "ASYNC"
    ]

    assert command == Protocol.addjob(queue_name, job, timeout, opts)
  end

  test "getjob with no opts" do
    queues = ["queue1", "queue2"]
    command = ["GETJOB", "FROM"] ++ queues
    assert command == Protocol.getjob(queues, [])
  end

  test "getjob with opts" do
    queues = ["queues1", "queues2"]
    opts = [
      nohang: true,
      withcounters: true,
      timeout: 10,
      count: 1
    ]
    command = [
      "GETJOB",
      "NOHANG",
      "WITHCOUNTERS",
      "TIMEOUT", "10",
      "COUNT", "1",
      "FROM"
    ] ++ queues
    assert command == Protocol.getjob(queues, opts)
  end

  test "acking multiple job ids" do
    job_ids = ["bMsnbwmqbbmnqw", "dbsmdsmbds"]
    command = ["ACKJOB"] ++ job_ids
    assert command == Protocol.ack(job_ids)
  end

  test "fastacking multiple job ids" do
    job_ids = ["bMsnbwmqbbmnqw", "dbsmdsmbds"]
    command = ["FASTACK"] ++ job_ids
    assert command == Protocol.fastack(job_ids)
  end
end
