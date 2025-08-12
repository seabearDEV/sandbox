defmodule MyFoo do
  def process_name(name, func) do
    func.(name)
  end

  def greeting_with_compliment(name, compliment \\ "You don't suck too much...") do
    IO.puts("Greetings #{name}! #{compliment}")
  end
end

test = &MyFoo.greeting_with_compliment(&1, "You are awesome!")

MyFoo.process_name("Bobby", test)
