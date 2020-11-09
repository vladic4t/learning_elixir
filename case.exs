defmodule Users do
  dave = %{name: "Dave", state: "TX", likes: "programming"}

  case dave do
    %{state: some_state} = person -> IO.puts("He lives in #{some_state}")
    _ -> IO.puts("NO matches")
  end
end
