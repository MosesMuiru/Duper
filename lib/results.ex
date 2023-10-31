defmodule Duper.Results do
  use GenServer

  @me __MODULE__

  # apis

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: @me)#start_link takes three arg the name of the module. the name of the function, also you can name the module of your chois
  end

  def add_hash_for(path, hash) do
    GenServer.cast(@me, { :add, path, hash})# cast takes two args, the name of the function and the name of the
  end

  def find_duplicate() do
    GenServer.call(@me, :find_duplicates) # me is the nam of the modules
  end

  # server
@doc """
init - initializes the values in the genserver

handle_cast -
handle call -- the is called by call()

Map.update takes a list or a map
  hash - this is the value to take
"""
  def init(:no_args) do # this is initializeing the args that will be uses in the server
    {:ok, %{}}
  end

  def handle_cast({:add, path, hash}, results) do

    results =
      Map.update(
        results, hash, [path],
        fn existing ->
          [ path | existing]
        end
      )
      {:noreply, results}
  end

  def handle_call(:find_duplicates, _from, results) do
    {:reply, hashes_with_more_than_one_path(results), results}
  end

  defp hashes_with_more_than_one_path(results) do
    results
    |> Enum.filter(fn{_hash, paths} -> length(paths) > 1 end)
    |> Enum.map(&elem(&1, 1))
  end
end
