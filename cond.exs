defmodule FizzBuzz do
  def upto(n) when n > 1 do
    _upto(1, n, [])
  end

  def _upto(_current, 0, result), do: Enum.reverse(result)

  defp _upto(current, left, result) do
    next_answer =
      cond do
        rem(current, 5) == 0 and rem(current, 3) == 0 -> "FizzBuzz"
        rem(current, 3) == 0 -> "Fizz"
        rem(current, 5) == 0 -> "Buzz"
        true -> current
      end

    _upto(current + 1, left - 1, [next_answer | result])
  end
end

defmodule FizzBuzz do
  def upto(n) when n > 1 do
    _downto(n, [])
  end

  def _downto[0, result], do: result

  defp _downto(current, result) do
    next_answer =
      cond do
        rem(current, 5) == 0 and rem(current, 3) == 0 -> "FizzBuzz"
        rem(current, 3) == 0 -> "Fizz"
        rem(current, 5) == 0 -> "Buzz"
        true -> current
      end

    _downto(n - 1, [next_answer | result])
  end
end

# AS A TRANSFORMATION
defmodule FizzBuzz do
  def upto(n) when n > 1 do
    1..n |> Enum.map(&fizzbuzz/1) # transformation
  end
  def fizzbuzz(n) do
    cond do
      rem(n, 5) == 0 and rem(n, 3) == 0 -> "FizzBuzz"
      rem(n, 5) -> "Buzz"
      rem(n, 3) -> "Fizz"
      true -> n
    end
  end
end

# ALTERNATIVE without cond
defmodule FizzBuzz do
  def upto(n) when n > 1 do
    1..n |> Enum.map(fizzbuzz/1)
  end
  def fizzbuzz(n), do: _fizzword(n, rem(n, 3), rem(n, 5))

  defp _fizzword(_n, 0, 0), do: "FizzBuzz"
  defp _fizzword(_n, 0, _), do: "Fizz"
  defp _fizzword(_n, _, 0), do: "Buzz"
  defp _fizzword(n, _, _), do: n
end