defmodule EnumMe do
    @comment """
    Iterates over the <enumerable> and invokes <function> on each element
    When an invocation of <function> returns a falsy value (false or nil)]
    iteration stops immediately and false is returned. In all other
    cases true is returned.
    """
    def all?([], _fun), do: true
    def all?([ head | tail ], fun) do
        if fun.(head) do
            all?(tail, fun)
        else
            false
        end
    end
    @comment """
        Invokes the given <function> for each element in the enumerable
    """
    def each([], _), do: :ok
    def each([ head | tail ], fun) do
        IO.inspect fun.(head)
        each(tail, fun)
    end
    @comment """
        Filters the <enumerable>, i.e: returns only those elements for which
        <function> returns a truthy variable
    """
    defp filter([], _, filtered), do: filtered
    defp filter([head | tail], fun, list) do
        if fun.(head) do
            filter(tail, fun, list ++ [head])
        else
            filter(tail, fun, list)
        end
    end
    def filter([head | tail], fun) do
        if fun.(head) do
            filter(tail, fun, [head])
        else
            filter(tail, fun, [])
        end
    end
    @comment """
        Splits <enumerable> into two <enumerables>, leaving count elements
        in the first one
    """
    defp _reverse([], store_head) do
        store_head
    end
    defp _reverse([head | tail], store_head) do
        reverse(tail, [head] ++ store_head)
    end
    def reverse([head | tail]) do
        _reverse(tail, [head])
    end
    def split([], c) do
        {[], []}
    end
    def split(list, count) when count == 0 do
        {[], list}
    end
    def split(list = [head | tail], count) when count > 0 do
        x = split(tail, count-1)
        {a, b} = x
        a = [head] ++ a
        return = {a, b}
        return
    end
    def split(list, count) when count < 0 do
        # we can make a private function _split to minimize
        # the use of reverse() on every recursive step
        # _split(list, count, initial_count)
        [head | tail] = reverse(list)
        x = split(tail, abs(count)-1)
        {a, b} = x
        a = [head] ++ a
        return = {reverse(b), reverse(a)}
        return
    end

end