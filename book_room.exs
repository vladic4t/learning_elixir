defmodule HotelRoom do

    def book(%{name: name, height: height})
    when height > 1.9 do
        IO.puts("Need extra long bed for #{name}")
    end
    
    def book(%{name: name, height: height})
    when height < 1.3 do
        IO.puts("Need low sher for controls for #{name}")
    end

    def book(person) do
        IO.puts("Need regular bed for #{person.name}")
    end

end

people = [
	%{ name: "Grumpy", height: 1.24 },
	%{ name: "Dave",   height: 1.88 },
	%{ name: "Vladimir", height: 1.7 },
	%{ name: "Sneezy", height: 1.28 },
]

people |> Enum.each(&HotelRoom.book/1)

data = %{ name: "Dave", state: "TX", likes: "Programming" }

for key <- [ :name, :likes ] do
    # key = [ :name, :likes ]
    # we pattern match the bounded data
    %{ ^key => value } = data
    value
end