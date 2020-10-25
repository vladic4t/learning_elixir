defmodule Recursion do
    def sum(0), do: 1
    def sum(n), do: n + sum(n-1)
    def gcd(x, 0), do: x
    def gcd(x, y), do: gcd(y, rem(x, y))
end

Enum.reduce(["now", "is", "the", "time"], fn (word, longest) ->
    IO.puts "#{word} #{longest}"
    if String.length(word) > String.length(longest) do
        word
    else
        longest
    end
end)

Enum.reduce(["now", "is", "the", "time"], 0, fn (word, longest) ->
    # longest = 0 (init)
    IO.puts "#{word}, #{longest}"
    if String.length(word) > longest,
    do: String.length(word),
    else: longest
end)