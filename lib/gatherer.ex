defmodule Duper.Gatherer do

  use GenServer
  alias Duper.Results

  @me Gatherer

  # the api
  def start_link(worker_count) do
    GenServer.start_link(__MODULE__, worker_count, name: @me)
  end

  def done() do
    GenServer.cast(@me, :done)
  end

  def results(path, hash) do
    GenServer.cast(@me, {:result, path, hash})
  end

  # the server
  def init(worker_count) do
    1..worker_count
    |> Enum.each(fn _ -> Duper.WorkerSupervisor.add_worker() end)
    { :ok ,  worker_count}
  end

  def handle_cast(:done, _worker_count = 1) do
    report_results()
    System.halt()
  end

  def handle_cast(:done, worker_count) do
    {:noreply, worker_count - 1}
  end

  def handle_cast({:results, path, hash}, worker_count) do
    Duper.Results.add_hash_for(path, hash)
    { :noreply, worker_count }

  end

  defp report_results() do
    IO.puts "Results: \n"
    Results.find_duplicate()
    |> Enum.each(&IO.inspect/1)
  end
end
