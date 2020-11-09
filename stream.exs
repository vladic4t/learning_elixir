defmodule Say do
	def openFile() do
		Stream.resource(
		    fn -> IO.open!("sample") end,
		    fn file ->
		        case IO.read(file, :line) do
		            data when is_binary(data) -> {[data], file}
		            _ -> {:halt, file}
		        end
		    end,
		    fn file -> File.close(file) end
		)
	end
	def say(text) do
		spawn fn -> :os.cmd('echo #{text}') end
	end
end

Stream.cycle(['green', 'white']) |> Stream.zip(1..5) |> Enum.map(fn {class, value} -> IO.puts("#{class}+#{value}")))
Stream.repeat(fn -> true end) |> Enum.take(3)
Stream.iterate(0, &(&1+1)) |> Enum.take(5)

file = Say.openFile()
# printer = file |> Stream.map(&IO.puts/1)
printer = file |> Stream.each(&IO.puts/1)
speaker = printer |> Stream.each(&Say.say/1)
speaker |> Enum.take(5)