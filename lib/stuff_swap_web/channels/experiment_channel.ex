defmodule StuffSwapWeb.ExperimentChannel do
  use StuffSwapWeb, :channel

  def join("topic:subtopic", _params, socket) do
    {:ok, socket}
  end

  def handle_in("some_exp", params, socket) do
    broadcast! socket, "some_exp", %{
      value1: params["value1"],
      value2: params["value2"]
    }

    {:reply, :ok, socket}
  end

  def handle_in("msgevent", params, socket) do
    push socket, "msgevent", %{ msg: params["msg"] }



    {:reply, :ok, socket}
  end
end