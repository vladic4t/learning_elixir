defmodule Chop do
    def check(input, n, _.._) when input == n do
        IO.puts("Your number is #{input}")
    end
    def check(input, n, low.._) when n > input do
        guess(input, low..n)
    end
    def check(input, n, _..high) when n < input do
        guess(input, n..high)
    end
    def guess(input, range) do
        low..high = range
        guess = div(low+high, 2)
        IO.puts("is it #{guess}?")
        check(input, guess, range)
    end
end