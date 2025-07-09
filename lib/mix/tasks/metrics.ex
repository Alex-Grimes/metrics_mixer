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

    IO.puts("\nTop 10 Most Changed Files (Last 90 Days):")
    IO.puts("-------------------------------------------")

    case calculate_churn() do
      :error ->
        IO.puts("Could not calculate churn. Are you in a git repository?")

      churn_data ->
        if Enum.empty?(churn_data) do
          IO.puts("No file changes found in the last 90 days.")
        else
          Enum.each(churn_data, fn {file, count} ->
            IO.puts("#{count} changes | #{file}")
          end)
        end
    end
  end

  defp calculate_churn do
    args = ["log", "--since=90.days.ago", "--name-only", "--pretty=format:"]

    case System.cmd("git", args) do
      {output, 0} ->
        output
        |> String.split("\n", trim: true)
        |> Enum.frequencies()
        |> Enum.sort_by(fn {_file, count} -> count end, :desc)
        |> Enum.take(10)

      {_output, _error_code} ->
        :error
    end
  end
end
