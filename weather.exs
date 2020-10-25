defmodule WeatherHistory do
    def for_location_27([]), do: []
    def for_location_27([ [time, 27, temp, rain] | tail ]) do
        [ [time, 27, temp, rain] | for_location_27(tail) ]
    end
    def for_location_27([ _ | tail]), do: for_location_27(tail)
end

defmodule WeatherHistory2 do
    def for_location([], _target_loc), do: []
    # fires only based on target_loc
    def for_location([ [time, target_loc, temp, rain] | tail ], target_loc) do
        [ [time, target_loc, temp, rain] | for_location(tail, target_loc) ]
    end
    def for_location([ _ | tail], target_loc), do: for_location(tail, target_loc)
end

defmodule WeatherHistory3 do
    def for_location([], _target_loc), do: []
    # fires only based on target_loc
    def for_location([ head = [_, target_loc, _, _] | tail ], target_loc) do
        [ head | for_location(tail, target_loc) ]
    end
    def for_location([ _ | tail], target_loc), do: for_location(tail, target_loc)
end