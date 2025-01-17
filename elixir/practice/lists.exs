# numbers = [1,2,3,4,5,6,7,8,9]
# Enum.each(
#   numbers,
#   fn (number) ->
#     IO.puts(number)
#   end
# )

defmodule Calculator do
  def sum_and_average(numbers) do
    sum = Enum.sum(numbers)
    average = sum / Enum.count(numbers)

    {sum, average}
  end

  def get_numbers_from_user do
    IO.puts("Enter a list of numbers separated by spaces: ")

    user_input = IO.gets("") |> String.trim()

    String.split(user_input, " ") |> Enum.map(&String.to_integer/1)
  end

  def print_numbers(numbers) do
    numbers |> Enum.join(" ") |> IO.puts()
  end
end

numbers = Calculator.get_numbers_from_user()
{sum, average} = Calculator.sum_and_average(numbers)
IO.puts("Sum: #{sum}, Average: #{average}")
