defmodule DisqueEx.MessageTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, conn} = DisqueEx.start_link()
    {:ok, conn: conn}
  end

  test "sending and receiving a message on a queue", %{conn: conn} do
    queue_name = "queue1"
    message_name = "Hello"
    {:ok, job_id} = DisqueEx.addjob(conn, queue_name, message_name)
    assert DisqueEx.getjob(conn, [queue_name]) == {:ok, [[queue_name, job_id, message_name]]}
  end

  test "acking a job", %{conn: conn} do
    queue_name = "queue2"
    message_name = "hello"
    {:ok, job_id} = DisqueEx.addjob(conn, queue_name, message_name)
    assert DisqueEx.getjob(conn, [queue_name]) == {:ok, [[queue_name, job_id, message_name]]}
    assert {:ok, 1} = DisqueEx.ackjob(conn, [job_id])
  end

  test "fastacking a job", %{conn: conn} do
    queue_name = "queue3"
    message_name = "hello"
    {:ok, job_id} = DisqueEx.addjob(conn, queue_name, message_name)
    assert DisqueEx.getjob(conn, [queue_name]) == {:ok, [[queue_name, job_id, message_name]]}
    assert {:ok, 1} = DisqueEx.fastack(conn, [job_id])
  end
end
