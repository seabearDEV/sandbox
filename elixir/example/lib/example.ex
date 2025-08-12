# Structs
defmodule Membership do
  defstruct [:type, :price]
end

defmodule User do
  defstruct [:name, :membership]
end

defmodule Example do
  use Application

  def start(_type, _args) do

    Example.main()

    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main do
    # Example.new_year_countdown()
    Example.learn_tuples()
  end

  def new_year_countdown do
    time = DateTime.new!(Date.new!(2026, 1, 1), Time.new!(0, 0, 0), "Etc/UTC")
    time_till = DateTime.diff(time, DateTime.utc_now())
    days = div(time_till, 86_400)
    hours = div(rem(time_till, 86_400), 60 * 60)
    minutes = div(rem(time_till, 60 * 60), 60)
    seconds = rem(time_till, 60)

    IO.puts("#{days} days, #{hours} hours, #{minutes} minutes, and #{seconds} seconds until the new year!")
  end

  def learn_tuples do
    gold_membership = %Membership{type: :gold, price: 25}
    silver_membership = %Membership{type: :silver, price: 20}
    bronze_membership = %Membership{type: :bronze, price: 15}
    none_membership = %Membership{type: :none, price: 0}

    users = [
      %User{name: "Alice", membership: gold_membership},
      %User{name: "Bob", membership: silver_membership},
      %User{name: "Charlie", membership: bronze_membership},
      %User{name: "David", membership: none_membership}
    ]

    Enum.each(users, fn %User{name: name, membership: membership} ->
      IO.puts("#{name} has a #{membership.type} membership paying #{membership.price} dollars.")
    end)
  end

end
