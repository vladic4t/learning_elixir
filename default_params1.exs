defmodule DefaultParams1 do
    def func(p1, p2 \\ 123)

    def func(p1, 99) do # matching
        IO.puts "You said 99"
    end

    def func(p1, p2) do
        IO.puts("Default #{p1} and #{p2} values")
    end

    defp private_fun(sth) do
        IO.puts sth
    end
end

DefaultParams1.func(2)
DefaultParams1.func(2, 22)
DefaultParams1.func(2, 99)

# defmodule Params do
#     def func(p1, p2 \\ 123) do
#         IO.puts("You called #{p1} and #{p2}")
#     end
#     def func(p1, p2) do
#         IO.puts("You called not default #{p1} and #{p2}")
#     end
# end