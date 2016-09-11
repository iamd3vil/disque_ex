defmodule DisqueEx.MessageTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, conn} = DisqueEx.start_link()
    {:ok, conn: conn}
  end

  test "sending and receiving a message on a queue", %{conn: conn} do
    queue_name = "queue1"
    message_name = "Hello"
    {:ok, tag} = DisqueEx.addjob(conn, queue_name, message_name)
    assert DisqueEx.getjob(conn, [queue_name]) == {:ok, [[queue_name, tag, message_name]]}
  end
end
