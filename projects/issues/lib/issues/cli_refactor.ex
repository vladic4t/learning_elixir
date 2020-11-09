defmodule Issues.CLI_Refactor do
  @default_count 4
  @moduledoc """
  Handle the command line parsing and the dispatch
  to the various functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help
  Otherwise it is a github user name, project nmae, and
  (optionally) the number of entries to format.

  Return a tuple of `{user, project, count}` or `:help` if help was given.
  """
  def parse_args(argv) do
    OptionParser.parse(argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  def args_to_internal_representation(_) do
    :help
  end

  def process(:help) do
    IO.puts("Usage: issues <user> <project> [count | #{@default_count}]")
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> last(count)
    |> format_table(["number", "created_at", "title"])
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from Github: #{error["message"]}")
    System.halt(2)
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i1, i2 ->
      i1["created_at"] >= i2["created_at"]
    end)
  end

  def last(list, count) do
    list |> Enum.take(5) |> Enum.reverse()
  end

  def format_table(elems, head) do
    # data_row = Enum.map(cols, &format_into_row(&1, head))
    Enum.map(elems, fn data -> Enum.map(head, fn col -> data[col] end) end)
    # return formated rows
    |> format_rows()
    |> format_header(head)
    |> print_to_console()
  end

  def print_to_console(list) do
    Enum.each(list, fn e ->
      Enum.each(e, fn data -> IO.write(data) end)
      IO.write("\n")
    end)
  end

  def format_rows(rows) do
    rows
    |> format_cols(length(rows))

    # |> iterate_rows(rows, &iterate_row/2)

    # for row <- rows do
    #   for {el, index} <- Enum.with_index(row, 1) do
    #     IO.puts(index)
    #     length = 0
    #     el = to_string(el)

    #     if index != length(row) do
    #       # el <> " | "
    #       return = "x"
    #       return
    #     else
    #       # el
    #       return = "y"
    #       return
    #     end
    #   end

    #   row ++ ["\n"]
    # end
  end

  defp format_col(el, check_length) when check_length > 1 do
    el <> " | "
  end

  defp format_col(el, check_length) do
    el
  end

  defp _format_cols([], store) do
    store
  end

  defp _format_cols([[el | tail] = row | rows], store) do
    # [next | next_row] = row
    # [next2 | next_row2] = next_row
    # [next3 | next_row3] = next_row2
    # IO.inspect(IEx.Info.info(next))
    # IO.inspect(IEx.Info.info(next2))
    # IO.inspect(IEx.Info.info(next3))
    # IO.puts("Printing row: #{row} with length: #{length(row)}\n")
    # IO.puts("Printing el: #{el} with length: #{length(row)}\n")
    # IO.puts("Printing next2: #{next2} with length: #{length(next_row2)}\n")
    # IO.puts("Printing next2: #{next3} with length: #{length(next_row3)}\n")
    # throwing "9603"
    el = to_string(el)
    nel = format_col(el, length(row))
    {cols, old} = store
    store = {[{nel, String.length(el)} | cols], [tail | old]}
    _format_cols(rows, store)
  end

  def format_cols(rows, len) do
    {cols, _} =
      Enum.reduce(Enum.to_list(1..len), 0, fn i, acc ->
        if acc == 0 do
          {_cols, old_rows} = _format_cols(rows, {[], []})
          {[_cols], old_rows}
        else
          {cols, _acc} = acc
          {_cols, old_rows} = _format_cols(Enum.filter(Enum.reverse(_acc), &(&1 != [])), {[], []})
          {[_cols | cols], old_rows}
        end
      end)

    # {cols1, old_rows} = _format_cols(rows, {[], []})
    # {cols2, old_rows} = _format_cols(Enum.reverse(old_rows), {[], []})
    # {cols3, old_rows} = _format_cols(Enum.reverse(old_rows), {[], []})
    # cols = [cols1, cols2, cols3]

    for col <- Enum.reverse(cols) do
      Enum.reverse(col)
    end
  end

  def format_header(cols, head) do
    max_len =
      for col <- cols do
        Enum.reduce(col, 0, fn {el, len}, track_length ->
          if len > track_length do
            len
          else
            track_length
          end
        end)
      end

    len_head = Enum.map(head, fn e -> String.length(to_string(e)) end)
    lens = Enum.zip(max_len, len_head)

    drawn =
      for {data_len, head_len} <- lens do
        String.duplicate("-", final_len_col_data(data_len, head_len)) <> "-+"
      end

    cols =
      for data <- cols do
        Enum.map(data, fn {e, _} -> e end)
      end

    [length_cols | tail] = Enum.map(cols, &Enum.count/1)

    rows = 1..length_cols |> Enum.map(&take_col(cols, &1))

    print = [drawn | rows]

    header =
      Enum.map(Enum.with_index(head, 1), fn {e, i} ->
        if i != length(head) do
          e <> " | "
        else
          e
        end
      end)

    [header | print]
  end

  defp final_len_col_data(data_len, head_len) do
    if data_len > head_len do
      data_len
    else
      head_len
    end
  end

  def take_col(cols, up_index) do
    _take_col(cols, up_index, [])
  end

  def _take_col([col | cols], up_index, store) do
    store = [
      Enum.with_index(col, 1)
      |> Enum.flat_map(fn {el, index} ->
        case take_at_index(el, index, up_index) do
          ^el -> [el]
          false -> []
        end
      end)
      | store
    ]

    _take_col(cols, up_index, store)
  end

  def _take_col([], _, store) do
    store |> Enum.reverse()
  end

  def take_at_index(el, index, up_index)
      when index == up_index do
    el
  end

  def take_at_index(el, index, up_index) do
    false
  end

  # ANOTHER METHOD

  # defp _iterate_rows([], _, store) do
  #   store
  # end

  # defp _iterate_rows([row | rows], fun, store) do
  #   store = [fun.(Enum.with_index(row, 1) |> Enum.reverse(), length(row)) | store]
  #   _iterate_rows(rows, fun, store)
  # end

  # def iterate_rows(rows, fun) do
  #   _iterate_rows(rows, fun, [])
  # end

  # defp _iterate_row([{el, index} | els], row_length, store) when row_length != index do
  #   store = [el <> " | " | store]
  #   _iterate_row(els, row_length, store)
  # end

  # defp _iterate_row([{el, index} | els], row_length, store) do
  #   store = [el <> "\n" | store]
  #   _iterate_row(els, row_length, store)
  # end

  # defp _iterate_row([], row_length, store) do
  #   store
  # end

  # def iterate_row(els, row_length) do
  #   _iterate_row(els, row_length, [])
  # end

  # RECURSIVE METHOD

  @recursive_method """
    def format_rows(rows) do
      _format_rows(rows, [])
    end

    defp _format_rows([row | tail], store) do
      store = format_row(Enum.with_index(row), Enum.length(row)) ++ ["\n"] ++ store
      _format_rows(tail, store)
    end

    defp _format_rows([], store) do
      store
    end

    def format_row(row, len) do
      _format_row(row, len, [])
    end

    defp _format_row([{el, index} | tail], len, store) when index != len do
      store = (el <> " | ") ++ store
      _format_row(tail, len, store)
    end

    defp _format_row([{el, index} | tail], len, store) do
      store = el ++ store
      _format_row(tail, len, store)
    end

    defp _format_row([], _, store) do
      store
    end
  """

  # END RECURSIVE METHOD

  def format_into_table([], cols) do
  end

  def format_into_row(col, data) do
    data[col]
  end
end
