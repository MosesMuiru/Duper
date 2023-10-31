defmodule Duper.ResultsTest do
  use ExUnit.Case

  alias Duper.Results

  test "can add entries to the reults" do
    Results.add_hash_for("path1", 123)
    Results.add_hash_for("path2", 234)
    Results.add_hash_for("path3", 123)
    Results.add_hash_for("path4", 432)
    Results.add_hash_for("path5", 234)

    duplicates = Results.find_duplicate()

    assert length(duplicates) == 2
    assert ~W{path3 path1} in duplicates
    assert ~W{path5 path2} in duplicates

  end

end
