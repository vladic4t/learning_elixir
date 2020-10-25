f2 = fn
        {0, 0, _} -> "FizzBuzz"
        {0, _, _} -> "Fizz"
        {_, 0, _} -> "Buzz"
    end

IO.puts(f2.({0, 1, 1}))
IO.puts(f2.({0, 0, 1}))
IO.puts(f2.({1, 0, 1}))