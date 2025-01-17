defmodule Guess do

  #Bootstrapping for Mix compilation
  use Application
  def start(_type, _args) do
    Guess.main()
    Supervisor.start_link([], strategy: :one_for_one)
  end

  #Main function
  def main do
    correct = :rand.uniform(10)
    IO.puts("Correct answer: #{correct}")

    guess = IO.gets("Guess a number between 1 and 10: ") |> String.trim() |> Integer.parse()
    IO.inspect(guess)

    case guess do
      {result, _} ->
        IO.puts("PARSE SUCCESSFUL: #{result}")

        if result === correct do
          IO.puts("You guessed #{result} and the correct answer was #{correct}, you win!")
        else
          IO.puts("You guessed #{result} and the correct answer was #{correct}, you lose!")
        end

      :error ->
        IO.puts("Something went wrong...")
    end
  end
end
