f2 = fn
        {0, 0, _} -> "FizzBuzz"
        {0, _, _} -> "Fizz"
        {_, 0, _} -> "Buzz"
        {_, _, n} -> n
    end

# IO.puts(f2.({0, 1, 1}))
# IO.puts(f2.({0, 0, 1}))
# IO.puts(f2.({1, 0, 1}))

f3 = fn (n) -> f2.({rem(n,3), rem(n,5), n}) end

IO.puts(f3.(10))
IO.puts(f3.(11))
IO.puts(f3.(12))
IO.puts(f3.(13))
IO.puts(f3.(14))
IO.puts(f3.(15))
IO.puts(f3.(16))