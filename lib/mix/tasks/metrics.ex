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

    pattern = Path.join(File.cwd!(), "lib/**/*.ex*")

    elixir_files = Path.wildcard(pattern)

    total_lines =
      elixir_files
      |> Enum.map(fn path -> File.stream!(path, :line, []) end)
      |> Enum.flat_map(fn stream -> Enum.to_list(stream) end)
      |> Enum.count()

    IO.puts("-----------------")
    IO.puts("Project Metrics:")
    IO.puts("-----------------")
    IO.puts("Total Elixir files: #{Enum.count(elixir_files)}")
    IO.puts("Total lines of code: #{total_lines}")
  end
end
