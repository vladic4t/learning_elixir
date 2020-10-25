defmodule RecursiveList do
    def len([]), do: 0
    def len([_head | tail]), do: 1 + len(tail)
    def square([]), do: []
    def square([head | tail]), do: [head*head | square(tail)]
    def map([], _fun), do: []
    def map([head | tail], fun), do: [fun.(head) | map(tail, fun)]
    def reduce([], value, fun), do: value
    # reduce applies the function to the lists' head and the current value, and passes
    # the result as the new current value when reducing the list's tail
    def reduce([head | tail], value, fun) do
        reduce(tail, fun.(head, value), fun)
    end
    def mapsum([head | tail], fun) do
        reduce(map([head | tail], fun), 0, &(&1+&2))
    end
    def get_max(value, max) when max > value do
        max
    end
    def get_max(value, max) when max < value do
        value
    end
    def max([head | tail]) do
        reduce(tail, head, fn (head, value) -> get_max(head, value) end)
    end
    def apply_caeser(e, n) when e > 122 do
        63
    end
    def apply_caeser(e, n) do
        e+n
    end
    def caeser(raw_string, n) do
        IO.puts(map(raw_string, &(apply_caeser(&1, n))))
    end
end