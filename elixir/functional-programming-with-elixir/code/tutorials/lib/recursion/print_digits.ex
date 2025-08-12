defmodule Tutorials.Recursion.PrintDigits do

  # Base Case
  def upto(0), do: 0

  # Recursive Case
  def upto(num) do
    IO.puts(num)
    upto(num - 1)
  end
end
