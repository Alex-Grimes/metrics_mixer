defmodule Mix.Tasks.Metrics do
  @moduledoc """
    Calculates various metrics for an Elixir project.
    To run the task: 
    mix metrics
  """
  use Mix.Task

  @shortdoc "Calculates project metrics"
  def run(_args) do
    IO.puts("Running project metrics task...")

    elixir_files =
      File.cwd!()
      |> File.ls!()
      |> Enum.filter(&String.ends_with?(&1, ".ex"))

    IO.puts("Found #{Enum.count(elixir_files)} .ex files.")
  end
end
